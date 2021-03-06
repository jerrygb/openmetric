# About this project

Openmetric is a collection and combination of metric related tools (mainly the *graphite stack*),
we provide (and only provide) docker images to make the stack deployment easy.
In the long term, we will enhance the stack so it can scale more easily.

# Docker images

There are several images you can choose from.

**openmetric/standalone-vanilla** is composed of official graphite components (i.e.
[carbon-relay.py](https://github.com/graphite-project/carbon/blob/master/bin/carbon-relay.py),
[carbon-aggregator.py](https://github.com/graphite-project/carbon/blob/master/bin/carbon-aggregator.py),
[carbon-cache.py](https://github.com/graphite-project/carbon/blob/master/bin/carbon-cache.py),
[graphite-web](https://github.com/graphite-project/graphite-web)
).
This should be enough for a small setup (less than 500 servers, depends on your hardware and metric volume).
This images exposes two interfaces, carbon-relay to accept metrics, and graphite-web for querying and graphing.

**openmetric/standalone** uses third-party implementation written in golang to replace the official one.
Currently they are
[carbon-c-relay](https://github.com/grobian/carbon-c-relay),
[go-carbon](https://github.com/lomik/go-carbon),
[carbonzipper](https://github.com/dgryski/carbonzipper),
[carbonapi](https://github.com/dgryski/carbonapi),
[grafana](https://github.com/grafana/grafana).

**openmetric/$component** is series of images contain just one component, so you can choose and deploy freely.

**openmetric/cluster** is a planned image, it aims to make clustering easier, you can run this same image on all cluster nodes,
with just a few parameters to set up a running cluster.

## Quick start

Start an openmetric instance:

```
docker run -d --name openmetric -p 2003:2003 -p 3000:3000 -p 5000:5000 openmetric/standalone
```

Visit ``http://openmetric-host:3000/``, you should see the grafana interface. Grafana default user is
`admin`, default password is generated randomly on initial start, you can find in docker logs:

```
docker logs openmetric | grep 'admin password'
```

It's time to push metrics to openmetric. Let's generate a series of random int values at 10s interval:

```
while true; do
  echo "test.random.int ${RANDOM} $(date +%s)"
done | nc openmetric-host 2003
```

You can now create dashboard in grafana, and start drawing graphs. Data source is registered on initial run.

## Directory layout in images

To make it easy to maintain the containers, we try to make directory layout consistent in all images.

All variable data are stored in ``/openmetric/$component/data``, configuration files are stored in
``/openmetric/$component/conf``, log files are stored in ``/openmetric/$component/log``.

Runnable binaries, scripts, libraries are installed in the system location (i.e. ``/usr`` or ``/usr/local``),
so there will be less problems with ``PATH`` env.


# Develop

## Build docker images

Since these images share common directories to `COPY` from, all `docker build` command should be run in the project root directory.
For example:

```
docker build -t openmetric/compiler -f dockerfiles/compiler .
```
