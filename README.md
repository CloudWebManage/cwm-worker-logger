# cwm-worker-logger

This logging component uses [fluentd](https://www.fluentd.org/) as its log
collector and forwarder. For the HTTP input from MinIO and their metrics
collection, a custom input plugin (`fluent-plugin-http-cwm`) has been used. Any
output plugins may be used as the log targets such as S3, ElasticSearch, etc.

For more details, please visit:

- [fluent-plugin-http-cwm](https://github.com/iamAzeem/fluent-plugin-http-cwm)
- [fluentd output plugins](https://docs.fluentd.org/output)

## Configuration

As the fluentd is the underlying logging engine, its configuration will be used.

For details, see [fluentd configuration](https://docs.fluentd.org/configuration).

The sample configuration files are located under the [config](config) folder.

| config file                               | default   | log targets               |
|:------------------------------------------|:---------:|:--------------------------|
| [fluent.conf](config/fluent.conf)         | Yes       | stdout only               |
| [fluent-s3.conf](config/fluent-s3.conf)   | -         | stdout + S3               |
| [fluent-es.conf](config/fluent-es.conf)   | -         | stdout + ElasticSearch    |

**NOTE**: By default, [stdout](https://docs.fluentd.org/output/stdout) is
enabled in all the sample config files.

## Run

Build and run the `docker-compose` stack:

```shell
docker-compose up -d --build
```

## Test

Send logs to the logger:

```shell
./tests/send_logs.sh localhost:8500/logs
```
