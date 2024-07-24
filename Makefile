APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=lonerko
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #arm64 windows
TARGETARCH=amd64 #arm64 amd64
IMAGE_TAG=${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build : format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o tbot -ldflags "-X="githhub.com/lienoweit/tbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf tbot
	docker rmi ${IMAGE_TAG}
