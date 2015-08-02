META_IMAGE?=wildducktheories/y2j

image:
	docker build -t $(META_IMAGE) .

push:
	docker push $(META_IMAGE)