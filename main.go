package main

import (
	"context"
	"database/sql"
	"github.com/heroiclabs/nakama-common/runtime"
)
func InitModule(ctx context.Context, logger runtime.Logger, db *sql.DB, nk runtime.NakamaModule, initializer runtime.Initializer) error {
	logger.Debug("==================GO SERVER RUNTIME CODE LOADED=================")
	initializer.RegisterRpc("foo", RpcTest)
	return nil
}

func RpcTest(ctx context.Context, logger runtime.Logger, db *sql.DB, nk runtime.NakamaModule, payload string) (string, error) {
	return "{}", nil
}