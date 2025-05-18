import 'package:flutter/material.dart';

class ColorNotifier extends ValueNotifier<Color> {
  ColorNotifier(Color value) : super(value);

  void updateColor(Color newColor) {
    value = newColor;
    notifyListeners();
  }
}
