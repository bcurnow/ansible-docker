#!/usr/bin/make

SHELL := /bin/bash
currentDir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
imageName := ansible
currentHost := $(shell hostname -A)

build:
	docker build \
	  -t ${imageName}:latest  \
	  ${currentDir}

create-inventory:
	echo "${currentHost} ansible_user=pi" > inventory

remove-inventory:
	rm inventory

run-ansible:
	docker run -it --mount type=bind,src="${currentDir}/inventory",target=/etc/ansible/hosts ${imageName}:latest

test: create-inventory run-ansible remove-inventory
