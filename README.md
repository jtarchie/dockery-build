# Introduction

This is designed to help with the development of CloudFoundry buildpacks. It is not a testing framework (yet).

# Prerequisites

If you are on Mac or Windows, [boot2docker](http://boot2docker.io/) is required. Download, install, and run the following commands to start it.

```sh
boot2docker init
boot2docker start
$(boot2docker shellinit)
```

# Usage

```sh
# Checkout the repo
git clone https://github.com/jtarchie/dockery-build
cd dockery-build

# build the required docker images
./bin/init

# run the buildpack script (detect, compile, and release)
./bin/deploy <buildpack_dir> <app_dir> [start command] [-e
ENV_VAR=ENV_VALUE]

# look at your pretty app -- the port is mapped to localhost via docker
open http://127.0.0.1:5000/

# cleanup any running docker instances and tmp directories
./bin/cleanup
```

# Deploying an app with a buildpack

There are two steps to a `bin/run`, staging and runtime.

## Staging

The staging of an application uses the buildpack to compile and
download the dependencies of an application.

## Runtime

The runtime will infer the start script of based on the `release`
step of a buildpack, the `Procfile` web definition, or the provided
`[start_command]` to the `bin/deploy` script.

## Database

Each application is provided with the service of a Postgres database. The
environment variables `DATABASE_URL` is provided to both staging and
runtime, so that it emulates a CloudFoundry service pipeline.

# Testing

Everything is a full integration test, so `docker` is required to be
installed.

```sh
bundle install
rspec
```

# Troubleshooting

* Since `boot2docker` does not do port forwarding correctly on some network setups. Try setting up a SSH tunnel with `boot2docker ssh -L 5000:localhost:5000`
