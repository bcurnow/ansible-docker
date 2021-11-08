#!/usr/bin/make

SHELL := /bin/bash
currentDir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
imageName := ansible
currentUser := $(shell id -u)
currentGroup := $(shell id -g)
currentHostIp := $(shell hostname -I | awk '{ print $$1 }')

build:
	docker build \
	  --build-arg USER_ID=${currentUser} \
	  --build-arg GROUP_ID=${currentGroup} \
	  -t ${imageName}:latest  \
	  ${currentDir}

create-inventory:
	echo "${currentHostIp} ansible_user=pi" > inventory

remove-inventory:
	rm inventory

run-ansible:
	docker run -it --mount type=bind,src="${currentDir}/inventory",target=/etc/ansible/hosts ${imageName}:latest

test: create-inventory run-ansible remove-inventory
