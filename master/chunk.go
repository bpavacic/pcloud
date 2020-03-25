package master

import (
	"pcloud/api"
)

type chunkServerStatus int

const (
	Healthy chunkServerStatus = iota
	UNREACHABLE
)

type chunkServer struct {
	address string
	status  chunkServerStatus
	chunks  map[string]api.ChunkStatus
}
