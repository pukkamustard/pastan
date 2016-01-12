from beets.plugins import BeetsPlugin
from beets.ui import Subcommand

import boto3
import tempfile
from boto3.s3.transfer import S3Transfer
from tinydb import TinyDB, where


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
        print self._temp.name
        try:
            self.s3transfer.download_file(
                self.bucket_name, 'db.json', self.db_path)
        except:
            pass

        self.db = TinyDB(self.db_path)
        self.items = self.db.table("items")

    def saveDB(self):
        self.db.close()
        self.s3transfer.upload_file(self.db_path, self.bucket_name, 'db.json')

    def post(self, lib_item, item=None):
        path = lib_item.path
        print lib_item.id, ": ", lib_item.artist, " - ", lib_item.title
        self.s3transfer.upload_file(path, self.bucket_name, str(lib_item.id))

        keys = lib_item.keys()
        new_item = {}
        for key in keys:
            new_item[key] = lib_item[key]

        if item:
            self.items.update(new_item, where('id') == new_item.id)
        else:
            self.items.insert(new_item)

    def sync_items(self, lib):
        lib_items = lib.items()
        for lib_item in lib_items:
            if self.items.contains(where('id') == lib_item.id):
                item = self.items.get(where('id') == lib_item.id)
                if (item["mtime"] < lib_item.mtime):
                    self.post(lib_item, item)
            else:
                self.post(lib_item)

    def pastan(self, lib, opts, args):
        self.before()
        self.sync_items(lib)
        print "Hello my name is Pastan!"
        self.after()
