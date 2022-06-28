FROM heroiclabs/nakama-pluginbuilder:3.11.0 AS go-builder
ENV GO111MODULE on
ENV CGO_ENABLED 1
WORKDIR /backend
COPY go.mod .
COPY vendor/ vendor/
COPY main.go .

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends gcc libc6-dev

RUN go build --trimpath --gcflags "all=-N -l" --mod=vendor --buildmode=plugin -o ./backend.so
RUN go install github.com/go-delve/delve/cmd/dlv@latest

FROM heroiclabs/nakama-dsym:3.11.0

COPY --from=go-builder /go/bin/dlv /nakama
COPY --from=go-builder /backend/backend.so /nakama/data/modules/
COPY local.yml /nakama/data/

ENTRYPOINT [ "/bin/bash" ]