package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"path/filepath"

	"charm.land/huh/v2"
)

var selection string

func copyFile(src, dst string, perm os.FileMode) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()

	out, err := os.OpenFile(dst, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, perm)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, in)
	return err
}

func clone() string {
	tmpDir, err := os.MkdirTemp("", "scaffolder-*")
	if err != nil {
		log.Fatal(err)
	}

	repoDir := filepath.Join(tmpDir, "scaffolder")

	cmd := exec.Command("git", "clone", "https://github.com/indium114/scaffolder", repoDir)
	cmd.Stdout = os.Stdout
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}

	return repoDir
}

func initialise(lang string) error {
	repoDir := clone()
	src := filepath.Join(repoDir, "scaffolds", selection)
	dst, err := os.Getwd()
	if err != nil {
		log.Fatal(err)
	}

	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		rel, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}

		target := filepath.Join(dst, rel)

		if info.IsDir() {
			return os.MkdirAll(target, info.Mode())
		}

		return copyFile(path, target, info.Mode())
	})
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

	err = initialise(selection)
	if err != nil {
		log.Fatal(err)
	}
}
