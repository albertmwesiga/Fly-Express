/// Aerial vehicle entity for transportation
class AerialVehicle {
  final String vehicleId;
  final String modelDesignation;
  final String registryCode;
  final SeatingConfiguration seatingConfig;
  final GeoPosition currentPosition;
  final VehicleOperationalState operationalState;
  final String? operatorId;
  final String? activeReservationId;
  final PowerStatus powerStatus;
  final String? vehicleImageUrl;
  
  AerialVehicle({
    required this.vehicleId,
    required this.modelDesignation,
    required this.registryCode,
    required this.seatingConfig,
    required this.currentPosition,
    required this.operationalState,
    this.operatorId,
    this.activeReservationId,
    required this.powerStatus,
    this.vehicleImageUrl,
  });
  
  Map<String, dynamic> serialize() => {
    'vehicleId': vehicleId,
    'modelDesignation': modelDesignation,
    'registryCode': registryCode,
    'seatingConfig': seatingConfig.serialize(),
    'currentPosition': currentPosition.serialize(),
    'operationalState': operationalState.name,
    'operatorId': operatorId,
    'activeReservationId': activeReservationId,
    'powerStatus': powerStatus.serialize(),
    'vehicleImageUrl': vehicleImageUrl,
  };
  
  factory AerialVehicle.deserialize(Map<String, dynamic> data) {
    return AerialVehicle(
      vehicleId: data['vehicleId'],
      modelDesignation: data['modelDesignation'],
      registryCode: data['registryCode'],
      seatingConfig: SeatingConfiguration.deserialize(data['seatingConfig']),
      currentPosition: GeoPosition.deserialize(data['currentPosition']),
      operationalState: VehicleOperationalState.values.byName(data['operationalState']),
      operatorId: data['operatorId'],
      activeReservationId: data['activeReservationId'],
      powerStatus: PowerStatus.deserialize(data['powerStatus']),
      vehicleImageUrl: data['vehicleImageUrl'],
    );
  }
}

class SeatingConfiguration {
  final int maximumCapacity;
  final int openSeats;
  
  SeatingConfiguration({
    required this.maximumCapacity,
    required this.openSeats,
  });
  
  bool get hasAvailability => openSeats > 0;
  
  Map<String, dynamic> serialize() => {
    'maximumCapacity': maximumCapacity,
    'openSeats': openSeats,
  };
  
  factory SeatingConfiguration.deserialize(Map<String, dynamic> data) {
    return SeatingConfiguration(
      maximumCapacity: data['maximumCapacity'],
      openSeats: data['openSeats'],
    );
  }
}

class GeoPosition {
  final double latitudeDegrees;
  final double longitudeDegrees;
  final double? altitudeMeters;
  
  GeoPosition({
    required this.latitudeDegrees,
    required this.longitudeDegrees,
    this.altitudeMeters,
  });
  
  Map<String, dynamic> serialize() => {
    'latitudeDegrees': latitudeDegrees,
    'longitudeDegrees': longitudeDegrees,
    'altitudeMeters': altitudeMeters,
  };
  
  factory GeoPosition.deserialize(Map<String, dynamic> data) {
    return GeoPosition(
      latitudeDegrees: data['latitudeDegrees'],
      longitudeDegrees: data['longitudeDegrees'],
      altitudeMeters: data['altitudeMeters'],
    );
  }
}

class PowerStatus {
  final double chargePercentage;
  final int estimatedRangeKm;
  
  PowerStatus({
    required this.chargePercentage,
    required this.estimatedRangeKm,
  });
  
  bool get needsCharging => chargePercentage < 20.0;
  
  Map<String, dynamic> serialize() => {
    'chargePercentage': chargePercentage,
    'estimatedRangeKm': estimatedRangeKm,
  };
  
  factory PowerStatus.deserialize(Map<String, dynamic> data) {
    return PowerStatus(
      chargePercentage: data['chargePercentage'],
      estimatedRangeKm: data['estimatedRangeKm'],
    );
  }
}

enum VehicleOperationalState {
  standingBy,
  inFlight,
  underMaintenance,
  charging,
}
