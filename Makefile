build: all

cur-dir   := $(shell basename `pwd`)
SET_PRIVATE="github.com/telegram-bot-app/*"
MICROSERVICE_NAME?=$(shell basename `git rev-parse --show-toplevel`)
GITHUB_COMMIT_NUMBER?=0
GITHUB_SHA?=$(shell git rev-parse HEAD)
COMMIT=$GITHUB_SHA
BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)

all:
	go build -o bot.bin -ldflags="-s -w -X main.SVC_RELEASE=6.1.${GITHUB_COMMIT_NUMBER} -X main.SVC_VERSION=`date +\"%Y%m%d%H%M\"`@${GITHUB_SHA} -X main.SVC_NAME=${MICROSERVICE_NAME}" *.go

test:
  GOPRIVATE=$(SET_PRIVATE) go test ./...

check:
	golangci-lint run *.go

update:
	GOPRIVATE=$(SET_PRIVATE) go get -u ./...

clean:
	rm *.bin
