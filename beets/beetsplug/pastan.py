from beets.plugins import BeetsPlugin
from beets.ui import Subcommand

import boto3
from boto3.s3.transfer import S3Transfer
import tempfile
import shutil
import plyvel
import tarfile


import json
import mimetypes


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
        # TODO: unicode...
        # print item.artist, " - ", item.title, " (", item.id, ")"
        id = str(item.id)
        try:
            self.upload_item(item)
            db.items.put(id, json.dumps(serialize(item)))
            print "Uploaded item #" + id
        except EnvironmentError:
            print "Can not read item #" + id
        except:
            print "Failed to Upload item #" + id

    def sync_items(self, lib):
        with PastanDB(self.s3, self.s3bucket) as db:
            counter = 0
            for item in lib.items():
                id = str(item.id)
                raw_db_item = db.items.get(id)
                if raw_db_item:
                    db_item = json.loads(raw_db_item)
                    # if already exists check modification time
                    if (db_item["mtime"] < item.mtime):
                        self.update_item(db, item)
                        counter = counter + 1
                    # TODO: check if item is on S3
                else:
                    self.update_item(db, item)
                    counter = counter + 1

                # Store the db every 20 uploaded files
                if counter > 20:
                    db.save()
                    counter = 0

    def sync_albums(self, lib):
        with PastanDB(self.s3, self.s3bucket) as db:
            for album in lib.albums():
                id = str(album.id)
                db.albums.put(id, json.dumps(serialize(album)))

    def pastan(self, lib, opts, args):
        # Set up connection to S3 and retrieve/initalize DB
        self.s3 = s3client(self.config)
        self.s3bucket = unicode(self.config['s3_bucket'])

        print "Hello, my name is Pastan."
        self.sync_items(lib)
        self.sync_albums(lib)


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
        self._path = tempfile.mkdtemp()
        print "db: path is ", self._path
        self._open()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self._db.close()
        if self._db.closed:
            print "db: uploading"
            try:
                self._upload()
                shutil.rmtree(self._path)
                print "db: uploaded and cleaned up"
            except:
                print "db: failed to upload or clean up"
        else:
            print "db: failed to close"

    def save(self):
        self._db.close()
        try:
            self._upload()
            print "db: uploaded"
        except:
            print "db: failed to save"
        self._open()

    def _open(self):
        try:
            self._download()
            print "db: ready"
        except:
            print "db: download failed, creating new"

        self._db = plyvel.DB(self._path + "/db", create_if_missing=True)
        self.items = self._db.prefixed_db(b'!items!')
        self.albums = self._db.prefixed_db(b'!albums!')

    def _download(self):
        tar_path = self._path + "/db.tar"
        self.s3.download_file(
            self.s3bucket, 'db.tar', tar_path)
        with tarfile.open(tar_path, "r") as tar:
            tar.extractall(self._path)

    def _upload(self):
        tar_path = self._path + "/db.tar"
        with tarfile.open(tar_path, "w") as tar:
            tar.add(self._path + "/db/", arcname="db")
        self.s3.upload_file(tar_path, self.s3bucket, 'db.tar')
