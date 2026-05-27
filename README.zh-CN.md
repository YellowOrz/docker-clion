## 说明

英文版本：[README.md](README.md)

- 这个项目几乎照搬自 https://github.com/linuxserver/docker-intellij-idea

- 构建和推送：

```bash
docker build --tag docker-clion:latest .
docker tag docker-clion:latest docker.io/orz2333/docker-clion:latest
docker push orz2333/docker-clion:latest
```

- 运行容器：

```bash
docker run -d \
  --name=docker-clion \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  orz2333/docker-clion:latest
```