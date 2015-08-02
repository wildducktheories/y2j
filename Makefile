DEFAULT_META_IMAGE=wildducktheories/y2j
META_IMAGE?=$(DEFAULT_META_IMAGE)

image:
	docker build -t $(META_IMAGE) .
	test "$(META_IMAGE)" = "$(DEFAULT_META_IMAGE)" || docker tag -f $$(docker commit $$(docker run -e META_IMAGE=$(META_IMAGE) $(META_IMAGE) sh -c 'echo $$HOSTNAME')) $(META_IMAGE)

push:
	docker push $(META_IMAGE)