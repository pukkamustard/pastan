# pastan

beets in the cloud.

This is the idea:

- Sync your local [beets](http://beets.io/) library to the cloud (Amazon S3).
- Run a small web service to access your library in the cloud.
- Use a web interface to listen to music from anywhere.

This is done with following components:

- Beets plugin: The plugin syncs your local library and a copy of the database to an Amazon S3 bucket. See `beets/` folder.
- Web service: A node.js application hosts a REST API allowing access your library from S3\. This runs somewhere in the cloud. See `server/` folder.
- An [elm](http://elm-lang.org/) web client that allows pretty access to your library in the cloud. See `client/` folder.

## Getting started

### Installation

Clone the repo.

### Amazon S3

You need to create an S3 bucket and access keys. Enable CORS.

### Beets plugin

Add the folder `beets/` to your `PYTHONPATH` (this will allow beets to find the plugin). For more information see: <http://beets.readthedocs.org/en/v1.3.17/dev/plugins.html>.

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

### Web service

In the `server/` folder:

- Install dependencies:

  ```
   npm install
  ```

- Set environment variables:

  ```
    export AWS_ACCESS_KEY_ID='your aws acces'
    export AWS_SECRET_ACCESS_KEY='secret'
    export AWS_REGION='eu-central-1'
    export PASTAN_S3_BUCKET='name-of-bucket'
  ```

- Start the server with `npm start`.

The server will be running at <http://localhost:8338/>.

### Client

In the `client/` folder:

- Install dependencies:

  ```
    npm Install
  ```

  - Start a webpack development server:

    ```
    npm start
    ```

The web interface is now accessible on <http://localhost:8088>.

## Related Projects and Ideas

Music streaming servers:

- [CherryMusic](http://www.fomori.org/cherrymusic/)
- [Sonerezh](https://www.sonerezh.bzh/)
- [Subsonic](http://www.subsonic.org)

Pastan is different by using S3\. You don't need a server with x Gigabytes of storage, just use S3.

Beets:

- [beets](http://beets.io/)
- beets web plugin: <http://beets.readthedocs.org/en/v1.3.17/plugins/web.html>
- There has been some discussion on designing new web API for beets: <https://github.com/beetbox/beets/issues/736>

Other:

- [Aura](https://github.com/beetbox/aura): REST API for music libraries
- [Tomahawk](https://www.tomahawk-player.org/): A music player that is able to connect with different kind of (online) sources. I tried to write a Tomahawk plugin. Will have to try again.
