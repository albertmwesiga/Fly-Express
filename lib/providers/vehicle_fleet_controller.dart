import 'package:flutter/foundation.dart';
import '../models/aerial_vehicle.dart';
import '../services/fleet_management_service.dart';

/// Controls aerial vehicle fleet operations
class VehicleFleetController with ChangeNotifier {
  final FleetManagementService _fleetManagement = FleetManagementService();
  
  List<AerialVehicle> _vehicleInventory = [];
  AerialVehicle? _chosenVehicle;
  bool _fetchingData = false;
  String? _operationError;
  
  List<AerialVehicle> get vehicleInventory => _vehicleInventory;
  AerialVehicle? get chosenVehicle => _chosenVehicle;
  bool get fetchingData => _fetchingData;
  String? get operationError => _operationError;
  
  Future<void> retrieveAvailableFleet() async {
    _fetchingData = true;
    _operationError = null;
    notifyListeners();
    
    try {
      _vehicleInventory = await _fleetManagement.fetchAvailableVehicles();
      _fetchingData = false;
      notifyListeners();
    } catch (error) {
      _operationError = error.toString();
      _fetchingData = false;
      notifyListeners();
    }
  }
  
  void chooseVehicle(AerialVehicle vehicle) {
    _chosenVehicle = vehicle;
    notifyListeners();
  }
  
  void resetChoice() {
    _chosenVehicle = null;
    notifyListeners();
  }
  
  Future<void> refreshVehicleLocation(String vehicleId, double lat, double lng) async {
    try {
      await _fleetManagement.updateVehiclePosition(vehicleId, lat, lng);
      await retrieveAvailableFleet();
    } catch (error) {
      _operationError = error.toString();
      notifyListeners();
    }
  }
  
  void setupMockFleet() {
    _fleetManagement.initializeMockFleet();
  }
}
