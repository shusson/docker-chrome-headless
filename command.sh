#!/bin/bash -e

echo "Executing command $@"
xvfb-run --server-args='-screen 0 1280x1024x24' $@
