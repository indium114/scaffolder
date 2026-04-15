package main

import (
	"log"
	"os"
	"os/exec"
	"path/filepath"

	"charm.land/huh/v2"
)

var selection string

func clone() {
	tmpDir, err := os.MkdirTemp("", "scaffolder-*")
	if err != nil {
		log.Fatal(err)
	}
	defer os.RemoveAll(tmpDir)

	repoDir := filepath.Join(tmpDir, "scaffolder")

	cmd := exec.Command("git", "clone", "https://github.com/indium114/scaffolder", repoDir)
	cmd.Stdout = os.Stdout
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}
}

func main() {
	form := huh.NewForm(
		huh.NewGroup(
			huh.NewSelect[string]().
				Title("Choose a Language").
				Options(
					huh.NewOption("Go", "go"),
				).
				Value(&selection),
		),
	)

	err := form.Run()
	if err != nil {
		log.Fatal(err)
	}
}
