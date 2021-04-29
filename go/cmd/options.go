package main

import (
	flutter_systray "github.com/JanezStupar/flutter_systray/go"
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/path_provider"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(1280, 800),
	flutter.AddPlugin(&flutter_systray.FlutterSystrayPlugin{}),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "https://sonr.io",
		ApplicationName: "Sonr",
	}),
}
