FROM golang:1.14-alpine as builder

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o kube-rbac-proxy

FROM gcr.io/distroless/static

COPY --from=builder /app/kube-rbac-proxy /usr/local/bin/kube-rbac-proxy

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/kube-rbac-proxy"]
