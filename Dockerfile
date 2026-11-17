FROM ghcr.io/xtls/xray-core:26.10.31 AS xray
FROM alpine:3.22

RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY --from=xray /usr/local/share/xray/ /usr/local/share/xray/
COPY config.json /usr/local/etc/xray/config.json
COPY entrypoint.sh /usr/local/bin/start-xray

ENV XRAY_LOCATION_ASSET=/usr/local/share/xray
USER 65532:65532
EXPOSE 3000
ENTRYPOINT ["/bin/sh", "/usr/local/bin/start-xray"]
