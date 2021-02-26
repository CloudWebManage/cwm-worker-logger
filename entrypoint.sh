#!/bin/sh

# source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    . $DEFAULT
    set +o allexport
fi

# Set FLUENTD_CONF according to LOG_PROVIDER environment variable
# Only the supported log targets are configured, default otherwise
CONF="default"
case "$LOG_PROVIDER" in
    "stdout") CONF=$LOG_PROVIDER ;;
    "elasticsearch") CONF=$LOG_PROVIDER ;;
    "s3") CONF=$LOG_PROVIDER ;;
esac

FLUENTD_CONF="cwm-fluent-${CONF}.conf"

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then
    if ! echo $@ | grep ' \-c' ; then
       set -- "$@" -c /fluentd/etc/${FLUENTD_CONF}
    fi

    if ! echo $@ | grep ' \-p' ; then
       set -- "$@" -p /fluentd/plugins
    fi
fi

exec "$@"
