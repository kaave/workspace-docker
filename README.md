# My workspace (2016.06)

## Checklist

- [ ] Add database containers
- [ ] ...and Orchestration

## setup

```bash
docker build --no-cache --rm -t private:workspace .
```

## How to use
### create container and attach

```bash
docker run -it -v ./work:/home/kaave/work --name workspace private:workspace /bin/zsh -l
```

### from next time

```bash
docker start workspace
docker exec -it workspace /bin/zsh -l
```


## My guide

[docker-composeを使って最高の開発環境を手に入れた](http://blog.muuny-blue.info/7d128c1d4a33165a8676d1650d8ff828.html)

