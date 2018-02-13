[![Docker Build Status](https://img.shields.io/docker/build/sebvaucher/sgx-base.svg)](https://hub.docker.com/r/sebvaucher/sgx-base/)

# Dockerization of SGX container built using Intel SDK

Instructions:
* Create a new image with this one as a base, or mount your source code at `/usr/src/app`
* The driver must be loaded in the host, but `aesmd` and `jhid` must be stopped

## Current supported versions

* sgx_1.9
* sgx_2.0
* sgx_2.1
* sgx_2.1.1

## Example Dockerfile

Example using `SampleEnclave` shipped with the official SDK

**Dockerfile**

```Dockerfile
FROM sebvaucher/sgx-base:sgx_1.9

COPY . ./
RUN make SGX_DEBUG=0 SGX_PRERELEASE=1 SGX_MODE=HW

CMD ["./app"]
```

**Building image**

```shell
$ docker build -t sampleenclave .
```

**Running in container**

```shell
$ docker run --device /dev/isgx --device /dev/mei0 sampleenclave
```
