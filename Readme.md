# pastan
Your music library in the cloud.

This is the idea:
- Sync your local beets ([http://beets.io/](http://beets.io/)) library to the cloud (Amazon S3).
- Run a small web service to access your library in the cloud.
- Use a web interface to listen to music from anywhere.

## Components
### Beets plugin
The plugin will provide a command to sync your library to some online storage.

See `beets/` folder.

### Web service
A tiny REST API that allows access to your library. Similar to the current beets web plugin ([http://beets.readthedocs.org/en/latest/plugins/web.html](http://beets.readthedocs.org/en/latest/plugins/web.html)).

See `service/` folder.

### A Web-based client
Listen to your music with any browser.

See `web/` folder.
