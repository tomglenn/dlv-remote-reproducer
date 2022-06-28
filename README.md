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

Migrate the database:

```
/nakama/nakama migrate up --database.address postgres:localdb@postgres:5432/nakama
```

Then run Nakama via dlv:

```
./dlv exec /nakama/nakama -- --config /nakama/data/local.yml --database.address postgres:localdb@postgres:5432/nakama
```

Break at a point in execution where the plugin should be loaded:

```
(dlv) break main.go:164
(dlv) continue
```

You should see in the output that the Nakama runtime plugin has loaded:

```
{"level":"debug","ts":"2022-06-28T15:59:24.926Z","caller":"nakama-server-sandbox/main.go:9","msg":"==================GO SERVER RUNTIME CODE LOADED=================","runtime":"go"}
```

Verify that the library is available using:

```
(dlv) libraries
0. 0x7fe608f90000 /lib/x86_64-linux-gnu/libdl.so.2
1. 0x7fe608f6f000 /lib/x86_64-linux-gnu/libpthread.so.0
2. 0x7fe608dae000 /lib/x86_64-linux-gnu/libc.so.6
3. 0x7fe608f9a000 /lib64/ld-linux-x86-64.so.2
4. 0x7fe5e05d2000 /lib/x86_64-linux-gnu/libnss_files.so.2
5. 0x7fe5d88ef000 /nakama/data/modules/backend.so
```

Break on the RpcTest function and continue:
```
(dlv) break RpcTest
Breakpoint 2 set at 0x7fe5d8d88700 for heroiclabs.com/nakama-server-sandbox.RpcTest() heroiclabs.com.-server-sandbox/main.go:14
(dlv) continue
```

Hit the RPC via the nakama console:
* http://localhost:7351 (admin/password). 
* API Explorer
* Choose "foo" from the dropdown, `00000000-0000-0000-0000-000000000000` as the userid and hit Send Request.

```
> heroiclabs.com/nakama-server-sandbox.RpcTest() heroiclabs.com.-server-sandbox/main.go:14 (hits goroutine(214):1 total:1) (PC: 0x7fc3b4d88700)
```