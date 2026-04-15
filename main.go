package main

import (
	"log"

	"charm.land/huh/v2"
)

var selection string

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
