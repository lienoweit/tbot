FROM golang:1.20 as builder

WORKDIR /go/src/app
copy . .
#RUN go mod download
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/tbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT [ "./tbot" ]