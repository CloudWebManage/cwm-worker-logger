FROM fluent/fluentd:v1.11-1

LABEL maintainer "Name <email>"
LABEL Description="<Description>" Vendor="<Vendor>" Version="<Version>"

USER root

RUN apk add --no-cache --update --virtual .build-deps \
    sudo build-base ruby-dev \
    # CWM HTTP input plugin for MinIO incoming logs
    && gem install fluent-plugin-http-cwm \
    # S3 output plugin for log target
    && sudo gem install fluent-plugin-s3 \
    # ElasticSearch output plugin for log target
    && sudo gem install fluent-plugin-elasticsearch \
    && sudo gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY config/fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/

ENV FLUENTD_CONF="fluent.conf"
ENV LD_PRELOAD=""

# expose HTTP input port
# EXPOSE 8080 8080

USER fluent
ENTRYPOINT ["tini", "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]
