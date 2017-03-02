#!/bin/bash

## This file is the entrypoint and is run as root user, we can fix
## directory permissions and then switch to openmetric user.

set -e

for subdir in conf log; do
    # We don't need to recursively chown. The directory permission
    # will be wrong only when a volume attached initially.
    # With large data directory, a recursive chown will also cause
    # a long lag.
    chown openmetric:openmetric "/openmetric/carbonapi/$subdir"
done

exec su-exec openmetric /usr/bin/carbonapi-wrapper
