#!/bin/bash
set -eux
cd "$(dirname "$(realpath "$0")")"
if ! docker images | grep sonm-kernel-builder; then
	docker build -t sonm-kernel-builder docker/
fi
rm -rf ../pkg-out/*
CTID=$(docker run --rm --user $(id -u):$(id -g) -d -v "$(dirname "$(pwd)")/pkg-out":/usr/src -v "$(pwd)":/usr/src/linux -w /usr/src/linux sonm-kernel-builder sleep infinity)
docker exec -u 0:0 $CTID groupadd -g $(id -g) sonm || true
docker exec -u 0:0 $CTID useradd -g $(id -g) -u $(id -u) sonm
docker exec $CTID make mrproper
docker exec $CTID make sonm_defconfig
KVER=$(docker exec $CTID make kernelversion)
docker exec $CTID make deb-pkg -j$(nproc) KDEB_PKGVERSION=${KVER} LOCALVERSION=
docker stop $CTID
echo "Artifacts are in $(dirname "$(pwd)")/pkg-out."
