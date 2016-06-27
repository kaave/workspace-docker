# My workspace (2016.06)

## Important

This workspace save dbdatas on `./data/{mysql,postgres,redis,mongodb}`.
If you remove these files, dbdatas remove too.

`./work` is working directory. this directory mount on dev container's `/home/kaave/work`.

## How to use
### create/download image

```bash
$ /usr/bin/env bash ./setup.sh
```

### start on Daemon mode

```bash
$ docker-compose up -d
```

### access to workspace:dev on ssh

```bash
$ ssh kaave@localhost -p 2222
# use sshpass
$ sshpass -p USERPASS ssh kaave@localhost -p 2222
```

## My guide

[docker-composeを使って最高の開発環境を手に入れた](http://blog.muuny-blue.info/7d128c1d4a33165a8676d1650d8ff828.html)
