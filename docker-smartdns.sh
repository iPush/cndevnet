#!/bin/bash -

docker run -d \
	-p 53:53/udp \
	--restart=always \
	--name cndevtun-smartdns \
	-v ${PWD}/smartdns:/smartdns \
	ghostry/smartdns