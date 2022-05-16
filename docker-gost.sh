#!/bin/bash -

docker run -d \
	--restart unless-stopped \
	--name cndevtun-gost \
	--network host \
	-v ${PWD}/gost:/gost \
	ginuerzh/gost -C /gost/config.json
