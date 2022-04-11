#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"

rm -drf docs

jazzy  --readme ./README.md \
       --build-tool-arguments -scheme,"RVS_MaskButton" \
       --github_url https://github.com/RiftValleySoftware/RVS_MaskButton \
       --title "RVS_MaskButton Doumentation" \
       --min_acl public \
       --output docs \
       --theme fullwidth
cp ./icon.png docs
cp ./img/* docs/img
