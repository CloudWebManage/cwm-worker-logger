# cwm-worker-logger

![ci](https://github.com/CloudWebManage/cwm-worker-logger/workflows/ci/badge.svg?branch=main&event=push)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/CloudWebManage/cwm-worker-logger)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/CloudWebManage/cwm-worker-logger/blob/master/LICENSE)

![Lines of code](https://img.shields.io/tokei/lines/github/CloudWebManage/cwm-worker-logger?label=LOC)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/CloudWebManage/cwm-worker-logger)
![GitHub repo size](https://img.shields.io/github/repo-size/CloudWebManage/cwm-worker-logger)

## Overview

This logging component uses [fluentd](https://www.fluentd.org/) as the log
collector and forwarder. For the HTTP input from MinIO and their metrics
collection, a custom input plugin (`fluent-plugin-http-cwm`) is used. Any output
plugins can be configured as the log targets such as S3, ElasticSearch, etc.

For more details, please visit:

- [fluent-plugin-http-cwm](https://github.com/iamAzeem/fluent-plugin-http-cwm)
- [fluentd output plugins](https://docs.fluentd.org/output)

## Configuration

As the fluentd is the underlying logging engine, its configuration is used.

For details, see [fluentd configuration](https://docs.fluentd.org/configuration).

The sample configuration files are located under the [config](config) folder.

| config file                                 |      log targets       |
| :------------------------------------------ | :--------------------: |
| [fluent.conf](config/fluent.conf) (default) |      stdout only       |
| [fluent-s3.conf](config/fluent-s3.conf)     |      stdout + S3       |
| [fluent-es.conf](config/fluent-es.conf)     | stdout + ElasticSearch |

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

## Contribute

- Fork the project.
- Check out the latest `main` branch.
- Create a feature or bugfix branch from `main`.
- Commit and push your changes.
- Make sure to add tests.
- Run Rubocop locally and fix all the lint warnings.
- Submit the PR.

## License

[MIT](./LICENSE)
