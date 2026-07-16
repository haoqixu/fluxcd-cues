module: "github.com/fluxcd/cues"
language: {
	version: "v0.9.0"
}
deps: {
	"cue.dev/x/crd/fluxcd.io@v0": {
		v:       "v0.2.0"
		default: true
	}
	"cue.dev/x/k8s.io@v0": {
		v:       "v0.7.0"
		default: true
	}
}
