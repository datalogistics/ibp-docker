# ibp-docker
Docker Container for the EODN IBP Server (Depot)

## Port setup

If using a Docker bridge, you will need to forward port 6714 to the container.

```
docker run -p 6714:6714 ibp
```

## Storage setup

By default, the container run script will generate IBP resources rooted at `/depot` in the container overlayfs.  This means any stored data is gone if the container goes away and the container was not committed at some point.  To have persistent storage, use a Docker mount:

```
docker run -v /HOST_DEPOT_MOUNT:/depot -p 6714:6714 ibp
```
Where `HOST_DEPOT_MOUNT` is the filesystem location where you'd like the container to store IBP allocations.

## Supported environment variables for registration and host configuration.

For EODN registration purposes, the following information should be set in environment variables passed to the container:

`PUBLIC_HOST` - The publically reachable hostname or IP of the host system or assigned container.
`INSTITUTION' - The institution or organization hosting this depot.
`COUNTRY`     - The hosting country.
`STATE`       - The hosting state.
`CITY`        - The hosting city.
`ZIPCODE`     - The hosting postal code.
`LATITUDE`    - Geographic latitude of the depot.
`LONGITUDE`   - Geographic longitude of the depot.

Example:

```
docker run -v /depot:/depot -p 6714:6714 -e PUBLIC_HOST='ibp2.open.sice.indiana.edu' -e INSTITUTION='IU' -e COUNTRY='US' -e ZIPCODE='47494' ibp
```
