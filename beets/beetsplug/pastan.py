from beets.plugins import BeetsPlugin
from beets.ui import Subcommand

import boto3
from boto3.s3.transfer import S3Transfer
import tempfile
import plyvel


import json
import mimetypes


DB_OFFLINE = True
OFFLINE_DB_PATH = '/tmp/pastan/'


class Pastan(BeetsPlugin):

    def commands(self):
        pastan = Subcommand('pastan', help='Hello, my name is pastan.')
        pastan.func = self.pastan
        return [pastan]

    def upload_item(self, item):
        path = item.path
        (ctype, encoding) = mimetypes.guess_type(path)
        self.s3.upload_file(path, self.s3bucket, str(item.id),
                            extra_args={'ContentType': ctype})

    def update_item(self, db, item):
        print item.artist, " - ", item.title, " (", item.id, ")"
        # self.upload_item(item)
        id = str(item.id)
        db.items.put(id, json.dumps(serialize(item)))

    def sync_items(self, lib):
        with PastanDB(self.s3, self.s3bucket) as db:
            for item in lib.items():
                id = str(item.id)
                raw_db_item = db.items.get(id)
                if raw_db_item:
                    db_item = json.loads(raw_db_item)
                    if (db_item["mtime"] < item.mtime):
                        self.update_item(db, item)
                else:
                    self.update_item(db, item)

    def pastan(self, lib, opts, args):
        # Set up connection to S3 and retrieve/initalize DB
        self.s3 = s3client(self.config)
        self.s3bucket = unicode(self.config['s3_bucket'])

        # self.db = PastanDB(self.s3, self.s3bucket)

        print "Hello, my name is Pastan."
        self.sync_items(lib)
        # self.sync_albums(lib)


def s3client(config):
    aws_access_key_id = unicode(config['aws_access_key_id'])
    aws_secret_access_key = unicode(config['aws_secret_access_key'])
    aws_region_name = unicode(config['aws_region_name'])
    client = boto3.client('s3', aws_access_key_id=aws_access_key_id,
                          aws_secret_access_key=aws_secret_access_key,
                          region_name=aws_region_name)
    return S3Transfer(client)


def serialize(item):
    # there must be a better way of doing this...
    keys = item.keys()
    serialized = {}
    for key in keys:
        serialized[key] = item[key]
    return serialized


class PastanDB:

    def __init__(self, s3, s3bucket):
        self.s3 = s3
        self.s3bucket = s3bucket

    def __enter__(self):
        self._db, self.items = self._open()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self._db.close()
        if self._db.closed:
            print "pastanDB closed."
        else:
            print "failed to close pastanDB."

    def _open(self):
        if DB_OFFLINE:
            db = plyvel.DB(OFFLINE_DB_PATH, create_if_missing=True)
            items = db.prefixed_db(b'items-')
            return db, items
        else:
            self._path = tempfile.mkdtemp()

    def saveDB(self):
        with open(self.db_path, 'w') as outfile:
            json.dump(self.db, outfile)
        self.s3.upload_file(self.db_path, self.s3bucket, 'db.json')
