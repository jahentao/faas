FROM golang:1.12 as build

ENV GO111MODULE=off
ENV CGO_ENABLED=0

ARG GIT_COMMIT_SHA
ARG GIT_COMMIT_MESSAGE
ARG VERSION='dev'
ARG ARCH="x86_64"
ARG GOOS=linux
ARG GOARM

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

FROM alpine:3.11

ARG ARCH="x86_64"

LABEL org.label-schema.license="MIT" \
    org.label-schema.vcs-url="https://github.com/openfaas/faas" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.name="openfaas/faas" \
    org.label-schema.vendor="openfaas" \
    org.label-schema.docker.schema-version="1.0"

RUN addgroup -S app \
    && adduser -S -g app app \
    && apk add --no-cache ca-certificates

WORKDIR /home/app

EXPOSE 8080
EXPOSE 8082
ENV http_proxy      ""
ENV https_proxy     ""

COPY --from=build /go/src/github.com/openfaas/faas/gateway/gateway    .
COPY assets     assets
RUN sed -ie s/x86_64/${ARCH}/g assets/script/funcstore.js && \
  rm assets/script/funcstore.jse

RUN chown -R app:app ./

USER app

CMD ["./gateway"]

