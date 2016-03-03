# pastan
Your music library in the cloud.

This is the idea:
- Sync your local [beets](http://beets.io/) library to the cloud (Amazon S3).
- Run a small web service to access your library in the cloud.
- Use a web interface to listen to music from anywhere.

This is done with following components:
- Beets plugin: The plugin syncs your local library and a copy of the database to an Amazon S3 bucket. See `beets/` folder.
- Web service: A node.js application hosts a REST API allowing access your library from S3. This is you would run somewhere in the cloud. See `api/` folder.
- An [elm](http://elm-lang.org/) web client that allows pretty access to your library in the cloud. See `client-src/` folder.

Current limitations are:
- No audio playback trough web client. You can create a playlist and download it as an m3u for playback.

## Getting started
### Installation
Clone the repo.

### Amazon S3
You need to create an S3 bucket and access keys.

### Beets plugin
Add the folder `beets/` to your `PYTHONPATH` (this will allow beets to find the plugin). For more information see: [http://beets.readthedocs.org/en/v1.3.17/dev/plugins.html](http://beets.readthedocs.org/en/v1.3.17/dev/plugins.html).

Add the `pastan` plugin and configurations to your beets `config.yaml`;

```
plugins:
    - pastan

pastan:
    aws_access_key_id: AWS_ACCESS_KEY_ID
    aws_secret_access_key: AWS_SECRET_ACCESS_KEY
    aws_region_name: AWS_REGION
    s3_bucket: AWS_S3_BUCKET
```

To sync run the command `beet pastan`.

### Pastan service and client
Run the command `npm install` to install dependencies.

Set environment variables:

```
export AWS_ACCESS_KEY_ID='your aws acces'
export AWS_SECRET_ACCESS_KEY='secret'
export AWS_REGION='eu-central-1'
export PASTAN_S3_BUCKET='name-of-bucket'
```

Start the monster with: `npm start`. This will compile the elm sources to the `client` folder and watch for changes with elm-live as well as start the node.js service with nodemon.

Point your browser to [http://192.168.99.1:8000/client](http://192.168.99.1:8000/client).

How it looks: ![Screenshot](doc/screenshots/items.png?raw=true)

## Todo
Service:
- Full text search. Also check why [jsonquery](https://www.npmjs.com/package/jsonquery) does not seem able to do regular expressions.
- Host web client as static content

Web frontend:
- play audio (currently it is only able to download an M3U)
- cover art
- proper styling

## Related Projects and Ideas
Music streaming servers:
- [CherryMusic](http://www.fomori.org/cherrymusic/)
- [Sonerezh](https://www.sonerezh.bzh/)
- [Subsonic](http://www.subsonic.org)

Pastan is different by using S3. You don't need a server with x Gigabytes of storage, just use S3.

Beets:
- [beets](http://beets.io/)
- beets web plugin: [http://beets.readthedocs.org/en/v1.3.17/plugins/web.html](http://beets.readthedocs.org/en/v1.3.17/plugins/web.html)
- There has been some discussion on designing new web API for beets: [https://github.com/beetbox/beets/issues/736](https://github.com/beetbox/beets/issues/736)

Other:
- [Aura](https://github.com/beetbox/aura): REST API for music libraries
- [Tomahawk](https://www.tomahawk-player.org/): A music player that is able to connect with different kind of (online) sources. I tried to write a Tomahawk plugin. Will have to try again.
