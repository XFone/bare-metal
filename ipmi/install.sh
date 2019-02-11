#!/bin/bash

go get github.com/rmxymh/infra-ecosphere
go get github.com/rmxymh/go-virtualbox
go get github.com/htruong/go-md2
go get github.com/gorilla/mux
go get github.com/jmcvetta/napping

cd ${GOPATH}/src/github.com/rmxymh/infra-ecosphere
go install
