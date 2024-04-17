import 'package:flutter/material.dart';

class EnvironmentProvider extends ChangeNotifier {
  String _selectedEnvironment = 'dev';

  String get selectedEnvironment => _selectedEnvironment;

  void setSelectedEnvironment(String environment) {
    _selectedEnvironment = environment;
    notifyListeners();
  }
}
