#!/usr/bin/env bash

TARGET="${1}"

[ "${TARGET}" == "" ] && echo missing TARGET && exit 1

echo sending logs to "${TARGET}"

while true; do
  while read -r line; do
    if ! curl -sX POST -H "Content-Type: application/json" -d "${line}" "${TARGET}"; then
      echo failed to post log line to target
      exit 1
    fi
    sleep 0.1
  done <tests/logs
  sleep 0.1
done
