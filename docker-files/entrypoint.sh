#!/bin/bash
set -e

avahi-daemon --daemonize --no-drop-root --no-rlimit

exec "$@"
