import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class InterestProvider with ChangeNotifier {
  final List<Vehicle> _interestedVehicles = [];

  List<Vehicle> get interestedVehicles => _interestedVehicles;

  void toggleInterest(Vehicle vehicle) {
    if (_interestedVehicles.any((v) => v.id == vehicle.id)) {
      _interestedVehicles.removeWhere((v) => v.id == vehicle.id);
    } else {
      _interestedVehicles.add(vehicle);
    }
    notifyListeners();
  }

  bool isInterested(String vehicleId) {
    return _interestedVehicles.any((v) => v.id == vehicleId);
  }
}
