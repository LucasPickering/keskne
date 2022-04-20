#!/bin/sh

saturate() {
    input_path=$1
    output_dir=$2
    output_path="$output_dir/$(basename $input_path)"
    echo "  $input_path > $output_path"
    envsubst < $input_path > $output_path
}

set -e
echo "Filling site template confs..."
saturate nginx.conf /etc/nginx/
for f in ./sites/*; do saturate $f /etc/nginx/conf.d/; done

nginx -g "daemon off;"
