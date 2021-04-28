package main

import (
	platform_device_id "github.com/BestBurning/platform_device_id/go"
	flutter_systray "github.com/JanezStupar/flutter_systray/go"
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/path_provider"
	sonr_plugin "github.com/sonr-io/plugin/go"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(1280, 800),
	flutter.AddPlugin(&sonr_plugin.SonrCorePlugin{}),
	flutter.AddPlugin(&flutter_systray.FlutterSystrayPlugin{}),
	flutter.AddPlugin(&platform_device_id.PlatformDeviceIdPlugin{}),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "https://sonr.io",
		ApplicationName: "Sonr",
	}),
}
