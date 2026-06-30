#!/usr/bin/env bash
set -o errexit

python manage.py migrate --noinput
python manage.py createcachetable my_cache_table || true

exec daphne shahen.asgi:application -b 0.0.0.0 -p "${PORT:-8000}"