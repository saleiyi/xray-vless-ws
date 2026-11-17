# Xray VLESS + WebSocket

容器在 `3000` 端口监听 `/ws`，公网入口通过支持 WebSocket 的 HTTPS 反向代理终止 TLS。

## 在 VPS 上运行

在仓库目录执行以下命令。保留 `.env` 以便重新部署时沿用同一个 UUID。

```sh
docker build -t xray-vless-ws .
if [ ! -e .env ]; then
    uuid=$(docker run --rm --entrypoint /usr/local/bin/xray xray-vless-ws uuid) &&
        (umask 077; printf 'XRAY_UUID=%s\n' "$uuid" > .env)
fi
docker run -d --restart unless-stopped --name xray-vless-ws \
    --env-file .env -p 127.0.0.1:3000:3000 xray-vless-ws
```

将域名指向 VPS。如果在宿主机上使用 Caddy，将下列站点加入 Caddyfile，并将 `node.example.com` 换成实际域名。

```caddyfile
node.example.com {
    reverse_proxy /ws 127.0.0.1:3000
}
```

如果由托管平台提供 HTTPS 入口，将服务端口设为 `3000`，将随机 UUID 保存为运行时环境变量 `XRAY_UUID`，并确认入口支持 WebSocket 升级。

## 客户端导入

将 `YOUR_UUID` 换成运行时设置的 UUID，并将链接中的 `node.example.com` 全部替换为实际域名。

```text
vless://YOUR_UUID@node.example.com:443?encryption=none&security=tls&type=ws&host=node.example.com&sni=node.example.com&alpn=http%2F1.1&path=%2Fws#Xray-WS
```
