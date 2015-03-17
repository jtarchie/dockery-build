#!/usr/bin/env bash

echo "All the environment variables"
env | ruby -p -e "gsub(/^/,'profile_')"
