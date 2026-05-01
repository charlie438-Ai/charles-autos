import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class CompareViewModel extends ChangeNotifier {
  final List<Vehicle> _selectedVehicles = [];
  bool _isCompareMode = false;

  List<Vehicle> get selectedVehicles => _selectedVehicles;
  bool get isCompareMode => _isCompareMode;
  bool get canCompare => _selectedVehicles.length >= 2;
  
  void toggleCompareMode() {
    _isCompareMode = !_isCompareMode;
    if (!_isCompareMode) {
      _selectedVehicles.clear();
    }
    notifyListeners();
  }

  bool isSelected(String vehicleId) {
    return _selectedVehicles.any((v) => v.id == vehicleId);
  }

  void toggleVehicle(Vehicle vehicle) {
    if (isSelected(vehicle.id)) {
      _selectedVehicles.removeWhere((v) => v.id == vehicle.id);
    } else {
      if (_selectedVehicles.length < 3) {
        _selectedVehicles.add(vehicle);
      }
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedVehicles.clear();
    notifyListeners();
  }
}
