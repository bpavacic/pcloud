local Kube = import "kube.libsonnet";

{
  "namespace.json": Kube.v1.Namespace("app-rpuppy"),
  "deployment.json": Kube.v1.Deployment("rpuppy", "app-rpuppy", [Kube.v1.Container("ruppy", "giolekva/rpuppy:latest")]),
}
