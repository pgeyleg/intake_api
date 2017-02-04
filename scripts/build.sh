#!/bin/bash
set -e

cd "$APP_HOME"

revision=$(git rev-parse --short HEAD)
output_dir="/build_artefacts"
input_dir="$APP_HOME"

rm -rf public/assets && RAILS_ENV=production

bundle exec fpm --deb-no-default-config-files -s dir -t deb --name "intake_api" \
--version "${APP_VERSION}" --package "$output_dir" "$input_dir"
