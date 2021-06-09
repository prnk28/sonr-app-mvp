package main

import (
	systray "github.com/sonr-io/systray/go"
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/path_provider"
	open_file "github.com/jld3103/go-flutter-open_file"
	file_picker "github.com/miguelpruivo/flutter_file_picker/go"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(1280, 800),
	flutter.WindowMode(flutter.WindowModeDefault),
	flutter.PopBehavior(flutter.PopBehaviorHide),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "https://sonr.io",
		ApplicationName: "Sonr",
	}),
	flutter.AddPlugin(&open_file.OpenFilePlugin{}),
	flutter.AddPlugin(&systray.SystrayPlugin{}),
	flutter.AddPlugin(&file_picker.FilePickerPlugin{}),
}
