# Docker image for running tests (karma, protractor) against Chrome inside xvbf

Based on https://github.com/jciolek/docker-protractor-headless

# Usage

```
docker run -it --privileged --rm --net=host -v /dev/shm:/dev/shm -v $(pwd):/tests shusson/chrome-tester [commands to run in xvbf]
```

## Why mapping `/dev/shm`?

Docker has hardcoded value of 64MB for `/dev/shm`. Because of that you can encounter an error [session deleted becasue of page crash](https://bugs.chromium.org/p/chromedriver/issues/detail?id=1097) on memory intensive pages. The easiest way to mitigate that problem is share `/dev/shm` with the host.

This needs to be done till `docker build` [gets the option `--shm-size`](https://github.com/docker/docker/issues/2606).

## Why `--privileged`?

Chrome uses sandboxing, therefore if you try and run Chrome within a non-privileged container you will receive the following message:

"Failed to move to new namespace: PID namespaces supported, Network namespace supported, but failed: errno = Operation not permitted".

The [`--privileged`](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) flag gives the container almost the same privileges to the host machine resources as other processes running outside the container, which is required for the sandboxing to run smoothly.

## Why `--net=host`?

This options is required **only** if the dockerised command requires a connection to the localhost on the host. Imagine this sscenario: you run an http test server on your local machine, let's say on port 8000. You type in your browser `http://localhost:8000` and everything goes smoothly. Then you want to run the dockerised Protractor against the same localhost:8000. If you don't use `--net=host` the container will receive the bridged interface and its own loopback and so the `localhost` within the container will refer to the container itself. Using `--net=host` you allow the container to share host's network stack and properly refer to the host when Protractor is run against `localhost`.

## `docker for mac` WARNING:
If you are using `docker for mac` you will have to manually tell the container how to connect to the host
see (https://forums.docker.com/t/access-host-not-vm-from-inside-container/11747/10)

    For example:
    $ sudo ifconfig lo0 alias 10.200.10.1/24
    $ docker run -it --rm --privileged --net=host --add-host=docker.local:10.200.10.1 -v /dev/shm:/dev/shm \
      -v $(pwd):/protractor shusson/chrome-tester --baseUrl='http://docker.local:5013'
