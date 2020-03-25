package client

import (
	"os"
	"testing"

	"google.golang.org/grpc"

	"pcloud/api"
	pt "pcloud/testing"
)

func TestUploadSmallFile(t *testing.T) {
	env, err := pt.NewInMemoryEnv(1)
	if err != nil {
		t.Error(err)
	}
	defer env.Stop()

	var opts []grpc.DialOption
	opts = append(opts, grpc.WithInsecure())
	opts = append(opts, grpc.WithBlock())
	conn, err := grpc.Dial("unix:///tmp/pcloud/master", opts...)
	if err != nil {
		t.Error(err)
	}
	defer conn.Close()
	client := api.NewMetadataStorageClient(conn)

	uploader := NewFileUploader(client)
	f, err := os.Open("testdata/foo")
	if err != nil {
		t.Error(err)
	}
	uploader.Upload(f)

}
