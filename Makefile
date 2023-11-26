APP := $(shell basename $(shell git remote get-url origin))
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)


GCLOUD_REGISTRY=gcr.io
GCLOUD_PROJECT=my-project-1522862239792

TARGETOS=linux  #linux darwin windows
TARGETARCH=amd64 #amd64 arm64 x86_64


build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o gobot -ldflags "-X="github.com/tavor118sn/gobot/cmd.appVersion=${VERSION}

image:
	docker build . -t $(GCLOUD_REGISTRY)/$(GCLOUD_PROJECT)/${APP}:${VERSION}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push $(GCLOUD_REGISTRY)/$(GCLOUD_PROJECT)/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf gobot
	docker rmi $(GCLOUD_REGISTRY)/$(GCLOUD_PROJECT)/${APP}:${VERSION}-${TARGETARCH}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get


