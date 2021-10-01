#!/bin/bash

DOCKER_BE=php

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

start: ## Start the containers
	cp -n docker-compose.yml.dist docker-compose.yml || true
	U_ID=1000 docker-compose up -d

stop: ## Stop the containers
	U_ID=1000 docker-compose stop

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) start

build: ## Rebuilds all the containers
	cp -n docker-compose.yml.dist docker-compose.yml || true
	U_ID=1000 docker-compose build

prepare: ## Runs backend commands
	$(MAKE) composer-install

# Backend commands
composer-install: ## Installs composer dependencies
	U_ID=1000 docker exec --user 1000 ${DOCKER_BE} composer install --no-interaction
# End backend commands

ssh-be: ## bash into the be container
	U_ID=1000 docker exec -it --user 1000 ${DOCKER_BE} bash
