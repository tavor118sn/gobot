APP=$(shell basename $(shell git remote get-url origin) | sed 's/\.git//')
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

GCLOUD_REGION=us-east1
GCLOUD_PROJECT=gobot-2023
GCLOUD_REPO=gobot-dev-repo

GITHUN_REPO=ghcr.io/tavor118sn

#linux darwin windows
TARGETOS=linux

#amd64 arm64 x86_64
TARGETARCH=amd64


build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o gobot -ldflags "-X="github.com/tavor118sn/gobot/cmd.appVersion=${VERSION}

image:
	docker build --platform=linux/amd64 . -t $(GITHUN_REPO)/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push $(GITHUN_REPO)/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf gobot
	docker rmi $(GITHUN_REPO)/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get


