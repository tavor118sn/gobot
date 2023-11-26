FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /go/src/app
COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN make build TARGETOS=$TARGETOS TARGETARCH=$TARGETARCH

# FROM scratch is a no-op in the Dockerfile, and will not create an extra layer in your image
FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/gobot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./gobot", "start"]
