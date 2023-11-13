#!make

include .env

export $(shell sed 's/=.*//' .env)

build:
	scripts/build.sh

clean:
	rm -rf build
