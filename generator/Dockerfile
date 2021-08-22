FROM grafana/promtail:2.3.0

RUN apt-get update && apt-get install -y netcat bc curl dumb-init bash procps coreutils vim net-tools

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "10", "500" ]
