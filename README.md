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
./bin/deploy <buildpack_dir> <app_dir>

# look at your pretty app -- the port is mapped to localhost via docker
open http://127.0.0.1:5000/

# cleanup any running docker instances and tmp directories
./bin/cleanup
```

# Troubleshooting

* Since `boot2docker` does not do port forwarding correctly on some network setups. Try setting up a SSH tunnel with `boot2docker ssh -L 5000:localhost:5000`
