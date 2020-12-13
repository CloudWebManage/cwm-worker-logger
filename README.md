# cwm-worker-logger

## Usage

Create a config file

```
mkdir -p .config
echo '{
    "HTTP_LISTEN_PORT": 8500,
    "DEBUG": true,
    "REDIS_HOST": "redis"
    "REDIS_PORT": 6379,
    "FLUSH_INTERVAL_SECONDS": 60,
    "REDIS_KEY_PREFIX_DEPLOYMENT_API_METRIC": "deploymentid:minio-metrics",
    "REDIS_KEY_PREFIX_DEPLOYMENT_LAST_ACTION": "deploymentid:last_action",
    "LOGS_TARGET": "s3",
    "LOGS_CONFIG": {
        "ACCESS_KEY_ID": "",
        "SECRET_ACCESS_KEY": ""
    }
}' > .config/config.json
```

Build and run the docker compose stack

```
docker-compose up -d --build
```

Send logs to the logger

```
tests/send_logs.sh localhost:8500
```