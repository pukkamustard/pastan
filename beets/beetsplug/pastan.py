from beets.plugins import BeetsPlugin
from beets.ui import Subcommand

import boto3
from boto3.session import Session
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

    def connectS3(self):
        aws_access_key_id = unicode(self.config['aws_access_key_id'])
        aws_secret_access_key = unicode(self.config['aws_secret_access_key'])
        aws_region_name = unicode(self.config['aws_region_name'])
        session = Session(aws_access_key_id=aws_access_key_id,
                          aws_secret_access_key=aws_secret_access_key,
                          region_name=aws_region_name)
        self.bucket_name = unicode(self.config['s3_bucket'])
        self.s3 = session.resource('s3')
        client = boto3.client('s3', aws_access_key_id=aws_access_key_id,
                              aws_secret_access_key=aws_secret_access_key,
                              region_name=aws_region_name)
        self.s3transfer = S3Transfer(client)

    def getDB(self):
        try:
            self.s3transfer.download_file(
                self.bucket_name, 'db.json', 'db.json')
        except:
            print "No DB."

        self.db = TinyDB('db.json')
        self.items = self.db.table("items")

    def saveDB(self):
        self.db.close()
        self.s3transfer.upload_file('db.json', self.bucket_name, 'db.json')

    def post(self, libItem, item=None):
        path = libItem.destination()
        print libItem.id, ": ", libItem.artist, " - ", libItem.title
        self.s3transfer.upload_file(path, self.bucket_name, str(libItem.id))

        newItem = {'id': libItem.id,
                   'mtime': libItem.mtime,
                   'title': libItem.title,
                   'artist': libItem.artist
                   }
        if item:
            self.items.update(newItem, where('id') == newItem.id)
        else:
            self.items.insert(newItem)

    def sync(self, lib):
        libItems = lib.items()
        for libItem in libItems:
            if self.items.contains(where('id') == libItem.id):
                item = self.items.get(where('id') == libItem.id)
                if (item["mtime"] < libItem.mtime):
                    self.post(libItem, item)
            else:
                self.post(libItem)

    def pastan(self, lib, opts, args):
        self.before()
        self.sync(lib)
        print "Hello my name is Pastan!"
        self.after()
