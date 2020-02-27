FROM golang:1.10.4 as build
ARG GIT_COMMIT_SHA
ARG GIT_COMMIT_MESSAGE
ARG VERSION='dev'

WORKDIR /go/src/github.com/openfaas/faas/gateway

COPY vendor         vendor

COPY handlers       handlers
COPY metrics        metrics
COPY requests       requests
COPY tests          tests

COPY types          types
COPY queue          queue
COPY plugin         plugin
COPY version        version
COPY scaling        scaling
COPY server.go      .

# Run a gofmt and exclude all vendored code.
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o gateway .

FROM alpine:3.8

RUN addgroup -S app \
    && adduser -S -g app app

WORKDIR /home/app

EXPOSE 8080
ENV http_proxy      ""
ENV https_proxy     ""

COPY --from=build /go/src/github.com/openfaas/faas/gateway/gateway    .
COPY assets     assets

RUN chown -R app:app ./

USER app

CMD ["./gateway"]
