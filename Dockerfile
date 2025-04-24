FROM nginx:alpine-slim

RUN apk add --no-cache unzip 

ENV PROMTAIL_VERSION=3.3.1
RUN curl -LO https://github.com/grafana/loki/releases/download/v${PROMTAIL_VERSION}/promtail-linux-amd64.zip && \
    unzip promtail-linux-amd64.zip && \
    mv promtail-linux-amd64 /usr/local/bin/promtail && \
    chmod +x /usr/local/bin/promtail && \
    rm promtail-linux-amd64.zip

RUN mkdir -p /etc/promtail /var/log/promtail
COPY promtail-config/ /etc/promtail/promtail-config.yaml
COPY nginx.conf /etc/nginx/conf.d
COPY certs /etc/nginx/certs

EXPOSE 80 443 9080
CMD ["sh", "-c", "nginx & promtail -config.file=/etc/promtail/promtail-config.yaml"]
