container:
	docker rm temp || true
	DOCKER_BUILDKIT=1 docker build -t test:0.3 .
	docker run --gpus all -it --name temp test:0.3