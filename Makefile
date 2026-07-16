# Flux cue utils

REPO_ROOT := $(shell git rev-parse --show-toplevel)
BUILD_DIR := $(REPO_ROOT)/build

all: vet fmt

vet:
	@cue vet ./... -c
	@cue vet ./pkg/... -c
	@cue vet ./generators/... -c
	@cue vet ./tools/... -c

fmt:
	@cue fmt ./...
	@cue fmt ./pkg/...
	@cue fmt ./generators/...
	@cue fmt ./tools/...

mod:
	@cue mod get cue.dev/x/k8s.io@latest cue.dev/x/crd/fluxcd.io@latest
	@cue mod tidy
