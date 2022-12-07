FROM golang:1.8.0-alpine

ADD . /go/src/app

WORKDIR /go/src/app

RUN GOOS=linux GOARCH=386 go build -v -o /go/src/app/jenkins-app

EXPOSE 3000
CMD ["./jenkins-app"]

