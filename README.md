# My workspace (2016.06)

## Checklist

- [ ] Add database containers
- [ ] ...and Orchestration

## setup

```bash
docker build --no-cache --rm -t private:workspace .
```

## How to use
### create/download image

```bash
$ docker-compose build
$ docker-compose pull
```

### start on Daemon mode

```bash
$ docker-compose up -d
```

### access to workspace:dev on ssh

```bash
$ ssh USERNAME@localhost -p 2222
# use sshpass
$ sshpass -p USERPASS ssh USERNAME@localhost -p 2222
```

## My guide

[docker-composeを使って最高の開発環境を手に入れた](http://blog.muuny-blue.info/7d128c1d4a33165a8676d1650d8ff828.html)
