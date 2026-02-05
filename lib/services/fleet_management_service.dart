import '../models/aerial_vehicle.dart';
import 'package:uuid/uuid.dart';

/// Mock service for managing aerial vehicles (drones)
class FleetManagementService {
  static final FleetManagementService _singleton = FleetManagementService._internal();
  factory FleetManagementService() => _singleton;
  FleetManagementService._internal();
  
  final _uuid = const Uuid();
  final List<AerialVehicle> _fleet = [];
  
  /// Initialize mock fleet data for Uganda
  void initializeMockFleet() {
    _fleet.clear();
    _fleet.addAll([
      _createMockVehicle(
        model: 'SkyFlyer X1',
        lat: 0.3476,  // Kampala
        lng: 32.5825,
        capacity: 4,
        openSeats: 2,
      ),
      _createMockVehicle(
        model: 'AeroTaxi Pro',
        lat: 0.0639,  // Entebbe
        lng: 32.4432,
        capacity: 6,
        openSeats: 4,
      ),
      _createMockVehicle(
        model: 'CloudRider 3000',
        lat: 0.4418,  // Jinja
        lng: 33.2042,
        capacity: 4,
        openSeats: 4,
      ),
      _createMockVehicle(
        model: 'UgandaAir Express',
        lat: -0.6033,  // Mbarara
        lng: 30.6582,
        capacity: 8,
        openSeats: 6,
      ),
    ]);
  }
  
  /// Get all available vehicles
  Future<List<AerialVehicle>> fetchAvailableVehicles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_fleet.isEmpty) initializeMockFleet();
    return _fleet.where((v) => 
      v.operationalState == VehicleOperationalState.standingBy && 
      v.seatingConfig.hasAvailability
    ).toList();
  }
  
  /// Get vehicle by ID
  Future<AerialVehicle?> fetchVehicleById(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _fleet.firstWhere((v) => v.vehicleId == vehicleId);
    } catch (e) {
      return null;
    }
  }
  
  /// Update vehicle location (for live tracking)
  Future<void> updateVehiclePosition(String vehicleId, double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _fleet.indexWhere((v) => v.vehicleId == vehicleId);
    if (index != -1) {
      final vehicle = _fleet[index];
      _fleet[index] = AerialVehicle(
        vehicleId: vehicle.vehicleId,
        modelDesignation: vehicle.modelDesignation,
        registryCode: vehicle.registryCode,
        seatingConfig: vehicle.seatingConfig,
        currentPosition: GeoPosition(
          latitudeDegrees: lat,
          longitudeDegrees: lng,
          altitudeMeters: vehicle.currentPosition.altitudeMeters,
        ),
        operationalState: vehicle.operationalState,
        operatorId: vehicle.operatorId,
        activeReservationId: vehicle.activeReservationId,
        powerStatus: vehicle.powerStatus,
        vehicleImageUrl: vehicle.vehicleImageUrl,
      );
    }
  }
  
  /// Assign pilot to vehicle
  Future<void> assignPilotToVehicle(String vehicleId, String pilotId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _fleet.indexWhere((v) => v.vehicleId == vehicleId);
    if (index != -1) {
      final vehicle = _fleet[index];
      _fleet[index] = AerialVehicle(
        vehicleId: vehicle.vehicleId,
        modelDesignation: vehicle.modelDesignation,
        registryCode: vehicle.registryCode,
        seatingConfig: vehicle.seatingConfig,
        currentPosition: vehicle.currentPosition,
        operationalState: vehicle.operationalState,
        operatorId: pilotId,
        activeReservationId: vehicle.activeReservationId,
        powerStatus: vehicle.powerStatus,
        vehicleImageUrl: vehicle.vehicleImageUrl,
      );
    }
  }
  
  AerialVehicle _createMockVehicle({
    required String model,
    required double lat,
    required double lng,
    required int capacity,
    required int openSeats,
  }) {
    return AerialVehicle(
      vehicleId: _uuid.v4(),
      modelDesignation: model,
      registryCode: 'UG-${_uuid.v4().substring(0, 6).toUpperCase()}',
      seatingConfig: SeatingConfiguration(
        maximumCapacity: capacity,
        openSeats: openSeats,
      ),
      currentPosition: GeoPosition(
        latitudeDegrees: lat,
        longitudeDegrees: lng,
        altitudeMeters: 1200.0,
      ),
      operationalState: VehicleOperationalState.standingBy,
      powerStatus: PowerStatus(
        chargePercentage: 85.0 + (capacity * 2.0),
        estimatedRangeKm: 150,
      ),
    );
  }
}
