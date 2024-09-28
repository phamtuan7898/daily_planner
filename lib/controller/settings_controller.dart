import 'package:flutter/material.dart';

class SettingsController with ChangeNotifier {
  bool _isDarkMode = false;
  Color primaryColor = Colors.blue;
  String fontFamily = 'Roboto'; // Mặc định
  Color _markerColor = Colors.blue; // Default marker color
  Color _textColor = Colors.black; // Default text color

  Color get _primaryColor => primaryColor;
  Color get markerColor => _markerColor;
  Color get textColor => _textColor;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void changePrimaryColor(Color color) {
    primaryColor = color;
    notifyListeners();
  }

  void changeFontFamily(String font) {
    fontFamily = font;
    notifyListeners();
  }

  void updateMarkerColor(Color color) {
    _markerColor = color;
    notifyListeners();
  }

  void updateTextColor(Color color) {
    _textColor = color;
    notifyListeners();
  }
}
