import 'package:flutter/material.dart';

class AppShadows {
  static const depth2 = BoxShadow(
    color: Color(0x330f0f0f),
    offset: Offset(0, 24),
    blurRadius: 24,
    spreadRadius: -16,
  );

  static const depth3 = BoxShadow(
    color: Color(0x1f0f0f0f),
    offset: Offset(0, 40),
    blurRadius: 32,
    spreadRadius: -24,
  );

  static const depth4 = BoxShadow(
    color: Color(0x1a0f0f0f),
    offset: Offset(0, 64),
    blurRadius: 64,
    spreadRadius: -48,
  );

  AppShadows._();
}
