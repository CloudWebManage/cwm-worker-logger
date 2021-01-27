FROM fluent/fluentd:v1.11-1

USER root

COPY fluent-plugin-http-cwm.version .

RUN apk add --no-cache --update --virtual .build-deps \
    sudo build-base ruby-dev \
    # CWM HTTP input plugin for MinIO incoming logs
    && sudo gem install fluent-plugin-http-cwm -v $(cat fluent-plugin-http-cwm.version) \
    # S3 output plugin for log target
    && sudo gem install fluent-plugin-s3 -v 1.5.0 \
    # ElasticSearch output plugin for log target
    && sudo gem install fluent-plugin-elasticsearch -v 4.3.3 \
    && sudo gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf *.version /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

ENV FLUENTD_CONF="fluent.conf"
ENV LD_PRELOAD=""

COPY entrypoint.sh /bin/

USER fluent
ENTRYPOINT ["tini", "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]
