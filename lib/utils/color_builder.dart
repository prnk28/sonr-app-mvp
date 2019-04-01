import 'dart:ui';
import "dart:math";
import 'package:flutter/material.dart';

// Init
LinearGradient _activeGradient;
Color _initialColor;

// Define Gradients
var azureLane = LinearGradient(
  // Where the linear gradient begins and ends
  begin: Alignment.topCenter,
  end: Alignment.bottomLeft,
  // Add one stop for each color.
  stops: [0.1, 0.6, 0.9],
  colors: [hexToColor("#7F7FD5"), hexToColor("#86A8E7"), hexToColor("#91EAE4")],
);

var megatron = LinearGradient(
  // Where the linear gradient begins and ends
  begin: Alignment.topCenter,
  end: Alignment.bottomLeft,
  // Add one stop for each color.
  stops: [0.1, 0.6, 0.9],
  colors: [hexToColor("#f7797d"), hexToColor("#FBD786"), hexToColor("#C6FFDD")],
);

// Load Gradients in Array
List<LinearGradient> gradients = [azureLane, megatron];

// Get Gradient Method
LinearGradient getRandomGradient() {
  final _random = new Random();
  _activeGradient = gradients[_random.nextInt(gradients.length)];
  _initialColor = _activeGradient.colors[0];
  return _activeGradient;
}

Color getInitialColor() {
  return _initialColor;
}

// Convert from HEX Value to Color
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
