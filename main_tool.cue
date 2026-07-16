package main

import (
	"strings"
	"tool/cli"
	"tool/exec"
	"tool/file"
)

sops: marker: "\"data\": \"ENC["

// The seal command encrypts with SOPS all CUE files  with the extension '.secrets.cue'.
command: seal: {
	gitRoot: exec.Run & {
		cmd: ["git", "rev-parse", "--show-toplevel"]
		stdout: string
		path:   strings.TrimSpace(stdout)
	}
	list: exec.Run & {
		cmd: ["find", gitRoot.path, "-type", "f", "-name", "*.secrets.cue", "-print0"]
		stdout: string
	}
	files: {
		for filepath in strings.Split(list.stdout, "\u0000") if filepath != "" {
			(filepath): {
				secret: file.Read & {
					filename: filepath
					contents: string
				}
				if !strings.Contains(secret.contents, sops.marker) {
					print: cli.Print & {
						text: "seal \(filepath)"
					}
					sops: exec.Run & {
						$after: print
						cmd: ["sops", "-e", "-i", filepath]
					}
				}
			}
		}
	}
}

// The unseal command decrypts with SOPS all CUE files with the extension '.secrets.cue'.
command: unseal: {
	gitRoot: exec.Run & {
		cmd: ["git", "rev-parse", "--show-toplevel"]
		stdout: string
		path:   strings.TrimSpace(stdout)
	}
	list: exec.Run & {
		cmd: ["find", gitRoot.path, "-type", "f", "-name", "*.secrets.cue", "-print0"]
		stdout: string
	}
	files: {
		for filepath in strings.Split(list.stdout, "\u0000") if filepath != "" {
			(filepath): {
				secret: file.Read & {
					filename: filepath
					contents: string
				}
				if strings.Contains(secret.contents, sops.marker) {
					print: cli.Print & {
						text: "unseal \(filepath)"
					}
					sops: exec.Run & {
						$after: print
						cmd: ["sops", "-d", "-i", filepath]
					}
				}
			}
		}
	}
}
