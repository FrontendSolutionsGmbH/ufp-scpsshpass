FROM alpine:latest

RUN apk update
RUN apk add sshpass
RUN apk add openssh