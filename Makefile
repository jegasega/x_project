IMAGE_NAME ?= jegasega/db_homework
IMAGE_TAG ?= $(shell cat db_homework/__init__.py | grep '^__version__ =' | sed "s/__version__ = ['\"]\(.*\)['\"].*/\1/")

docker-build:
	$(info ******** Building docker image ********)
	docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
	docker tag ${IMAGE_NAME}:${IMAGE_TAG}  ${IMAGE_NAME}:latest	 

docker-push:
	$(info ******** Uploading image to the docker registry ********)
	docker push ${IMAGE_NAME}:latest

run-test:
	$(info ********** Running tests ********)
	docker compose up -d
	sleep 20
	pipenv run pytest
	docker compose down

run-flake:
	$(info ********** Running style checks ********)
	pipenv run flake8

run-mypy:
	$(info ********** Running types checks ********)
	pipenv run mypy

clean:
	docker ps -aq | xargs docker rm
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info

clean-dist:
	rm -rf dist/ build/
	rm -rf *.egg-info

test: run-flake run-mypy run-test clean

build: clean test docker-build docker-push
