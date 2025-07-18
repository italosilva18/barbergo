
# syntax=docker/dockerfile:1
FROM golang:1.23-alpine

RUN apk add --no-cache gcc musl-dev sqlite-dev

WORKDIR /app

COPY go.mod go.sum ./ 
RUN go mod download

COPY . .

ENV CGO_ENABLED=1
RUN go build -o /barbergo-api

EXPOSE 8080

CMD [ "/barbergo-api" ]
