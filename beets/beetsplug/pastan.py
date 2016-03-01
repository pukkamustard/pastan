from beets.plugins import BeetsPlugin
from beets.ui import Subcommand

import boto3
import tempfile
from boto3.s3.transfer import S3Transfer

import json
import mimetypes


class Pastan(BeetsPlugin):

    def commands(self):
        pastan = Subcommand('pastan', help='I do not do anything.')
        pastan.func = self.pastan
        return [pastan]

    def before(self):
        self.connectS3()
        self.getDB()

    def after(self):
        self.saveDB()
        self._temp.close()

    def connectS3(self):
        aws_access_key_id = unicode(self.config['aws_access_key_id'])
        aws_secret_access_key = unicode(self.config['aws_secret_access_key'])
        aws_region_name = unicode(self.config['aws_region_name'])
        self.bucket_name = unicode(self.config['s3_bucket'])
        client = boto3.client('s3', aws_access_key_id=aws_access_key_id,
                              aws_secret_access_key=aws_secret_access_key,
                              region_name=aws_region_name)
        self.s3transfer = S3Transfer(client)

    def getDB(self):
        self._temp = tempfile.NamedTemporaryFile()
        self.db_path = self._temp.name
        # self.db_path = "db.json"
        print self._temp.name
        try:
            self.s3transfer.download_file(
                self.bucket_name, 'db.json', self.db_path)
            with open(self.db_path) as data_file:
                self.db = json.load(data_file)
        except:
            self.db = {'items': {}}

    def saveDB(self):
        with open(self.db_path, 'w') as outfile:
            json.dump(self.db, outfile)
        self.s3transfer.upload_file(self.db_path, self.bucket_name, 'db.json')

    def upload(self, lib_item):
        path = lib_item.path
        (ctype, encoding) = mimetypes.guess_type(path)
        print "Uploading: ", lib_item.artist, " - ", lib_item.title, "(", lib_item.id, ")"
        self.s3transfer.upload_file(path, self.bucket_name, str(lib_item.id),
                                    extra_args={'ContentType': ctype})

        keys = lib_item.keys()
        new_item = {}
        for key in keys:
            new_item[key] = lib_item[key]

        self.db['items'][lib_item.id] = new_item

    def sync_items(self, lib):
        lib_items = lib.items()
        items = self.db['items']
        for lib_item in lib_items:
            id = str(lib_item.id)
            if id in items:
                item = items[id]
                if (item["mtime"] < lib_item.mtime):
                    self.upload(lib_item)
            else:
                self.upload(lib_item)

    def sync_albums(self, lib):
        self.db['albums'] = {}
        for album in lib.albums():
            keys = album.keys()
            a = {}
            for key in keys:
                a[key] = album[key]
            self.db['albums'][album.id] = a

    def pastan(self, lib, opts, args):
        self.before()
        self.sync_items(lib)
        self.sync_albums(lib)
        self.after()
