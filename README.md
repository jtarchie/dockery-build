# Instruction

```sh
boot2docker init
boot2docker start
$(boot2docker shellinit)

git clone https://github.com/jtarchie/dockery-build
cd dockery-build
docker build -t dockery-build .
./bin/build <buildpack_dir> <app_dir>
open http://$(boot2docker ip):5000/
./bin/cleanup
```
