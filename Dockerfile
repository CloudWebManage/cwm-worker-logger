FROM fluent/fluentd:v1.11-1

USER root

COPY fluent-plugin-cwm-http.version .

RUN apk add --no-cache --update --virtual .build-deps \
    sudo build-base ruby-dev \
    # CWM HTTP input plugin for MinIO incoming logs
    && sudo gem install fluent-plugin-cwm-http -v $(cat fluent-plugin-cwm-http.version) \
    # S3 output plugin for log target
    && sudo gem install fluent-plugin-s3 -v 1.5.0 \
    # ElasticSearch output plugin for log target
    && sudo gem install fluent-plugin-elasticsearch -v 4.3.3 \
    && sudo gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf *.version /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY ./config/*.conf /fluentd/etc/
COPY entrypoint.sh /bin/

ENV LD_PRELOAD=""

# use UTC timezone
ENV TZ="UTC"

USER fluent
ENTRYPOINT ["tini", "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]
