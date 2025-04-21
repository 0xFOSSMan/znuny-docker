.PHONY: build rebuild push run up down

build:
	export COMPOSE_BAKE=true && \
	docker compose build -t znuny-docker:latest

rebuild:
	export COMPOSE_BAKE=true && \
	docker compose down && \
	docker compose build -t znuny-docker:latest && \
	docker compose up -d

push:
	docker push ghcr.io/0xfossman/znuny-docker:latest

run:
	docker compose up -d && \
	docker compose logs -f

up:
	docker compose up -d

down:
	docker compose down