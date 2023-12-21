APP=$(shell basename $(shell git remote get-url origin) | sed 's/\.git//')
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

GCLOUD_REGION=us-east1
GCLOUD_PROJECT=gobot-2023
GCLOUD_REPO=gobot-dev-repo

TARGETOS=linux  #linux darwin windows
TARGETARCH=amd64 #amd64 arm64 x86_64


build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o gobot -ldflags "-X="github.com/tavor118sn/gobot/cmd.appVersion=${VERSION}

image:
	docker build --platform=linux/amd64 . -t $(GCLOUD_REGION)-docker.pkg.dev/$(GCLOUD_PROJECT)/$(GCLOUD_REPO)/${APP}:${VERSION}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push $(GCLOUD_REGION)-docker.pkg.dev/$(GCLOUD_PROJECT)/$(GCLOUD_REPO)/${APP}:${VERSION}-${TARGETARCH}

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


