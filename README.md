# Delve plugin debugging reproducer

## Usage

Run the containers:

```
docker compose up
```

Exec into the Nakama container

```
docker exec -it dlv-remote-reproducer-nakama-1 /bin/bash
```

Move up a directory and migrate the database:

```
cd ..
/nakama/nakama migrate up --database.address postgres:localdb@postgres:5432/nakama
```

Then run Nakama via dlv:

```
/dlv exec /nakama/nakama -- --config /nakama/data/local.yml --database.address postgres:localdb@postgres:5432/nakama
```

Break at a point in execution where the plugin should be loaded:

```
(dlv) break main.go:178
(dlv) continue
```

You should see in the output that Nakama has finished starting up:

```
{"level":"info","ts":"2022-06-28T14:16:51.366Z","caller":"v3/main.go:175","msg":"Startup done"}
```

I then expect to be able to debug the plugin code here (such as the RpcTest function) but dlv cannot find it.

```
(dlv) funcs RpcTest
(dlv)
```