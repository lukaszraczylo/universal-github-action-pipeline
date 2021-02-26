# syntax=docker/dockerfile:1.2.1-labs
FROM golang:1-alpine as baseimg
ARG GITHUB_AUTH_TOKEN
ARG GITHUB_COMMIT_NUMBER
ARG GITHUB_SHA
ARG MICROSERVICE_NAME

RUN apk add git make
WORKDIR /go/src/app
ENV GO111MODULE=on CGO_ENABLED=1 GOOS=linux
COPY . /go/src/app/
ENV ci_github_auth_var=https://${GITHUB_AUTH_TOKEN}:x-oauth-basic@github.com/telegram-bot-app
RUN git config --global url.${ci_github_auth_var}.insteadOf "https://github.com/telegram-bot-app"
RUN make update && make GITHUB_AUTH_TOKEN=${GITHUB_AUTH_TOKEN} MICROSERVICE_NAME=${MICROSERVICE_NAME} GITHUB_COMMIT_NUMBER=${GITHUB_COMMIT_NUMBER} GITHUB_SHA=${GITHUB_SHA}

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /go/src/app
COPY --from=baseimg /go/src/app/service.bin .
EXPOSE 8888
EXPOSE 80
CMD ["./service.bin"]
