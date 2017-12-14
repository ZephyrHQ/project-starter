#!/bin/bash
set -e

cd /app
yarn install
#yarn upgrade

exec "$@"
