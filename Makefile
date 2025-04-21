.PHONY: build rebuild push

build:
	export COMPOSE_BAKE=true && \
	docker compose build .

rebuild:
	export COMPOSE_BAKE=true && \
	docker compose down && \
	docker compose build . && \
	docker compose up -d

push:
	docker push ghcr.io/0xFOSSMan/znuny-docker:latest