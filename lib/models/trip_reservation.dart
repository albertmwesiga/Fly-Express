/// Trip reservation entity
class TripReservation {
  final String reservationId;
  final String customerId;
  final String vehicleId;
  final String? assignedPilotId;
  final TripRoute route;
  final DateTime scheduledDeparture;
  final PassengerPreferences preferences;
  final PricingDetails pricing;
  final TransactionMethod paymentMethod;
  final ReservationState currentState;
  final DateTime createdTimestamp;
  final DateTime? finishedTimestamp;
  final TripEstimates estimates;
  final WeatherInfo? weatherInfo;
  
  TripReservation({
    required this.reservationId,
    required this.customerId,
    required this.vehicleId,
    this.assignedPilotId,
    required this.route,
    required this.scheduledDeparture,
    required this.preferences,
    required this.pricing,
    required this.paymentMethod,
    required this.currentState,
    required this.createdTimestamp,
    this.finishedTimestamp,
    required this.estimates,
    this.weatherInfo,
  });
  
  Map<String, dynamic> serialize() => {
    'reservationId': reservationId,
    'customerId': customerId,
    'vehicleId': vehicleId,
    'assignedPilotId': assignedPilotId,
    'route': route.serialize(),
    'scheduledDeparture': scheduledDeparture.millisecondsSinceEpoch,
    'preferences': preferences.serialize(),
    'pricing': pricing.serialize(),
    'paymentMethod': paymentMethod.name,
    'currentState': currentState.name,
    'createdTimestamp': createdTimestamp.millisecondsSinceEpoch,
    'finishedTimestamp': finishedTimestamp?.millisecondsSinceEpoch,
    'estimates': estimates.serialize(),
    'weatherInfo': weatherInfo?.serialize(),
  };
  
  factory TripReservation.deserialize(Map<String, dynamic> data) {
    return TripReservation(
      reservationId: data['reservationId'],
      customerId: data['customerId'],
      vehicleId: data['vehicleId'],
      assignedPilotId: data['assignedPilotId'],
      route: TripRoute.deserialize(data['route']),
      scheduledDeparture: DateTime.fromMillisecondsSinceEpoch(data['scheduledDeparture']),
      preferences: PassengerPreferences.deserialize(data['preferences']),
      pricing: PricingDetails.deserialize(data['pricing']),
      paymentMethod: TransactionMethod.values.byName(data['paymentMethod']),
      currentState: ReservationState.values.byName(data['currentState']),
      createdTimestamp: DateTime.fromMillisecondsSinceEpoch(data['createdTimestamp']),
      finishedTimestamp: data['finishedTimestamp'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(data['finishedTimestamp']) 
        : null,
      estimates: TripEstimates.deserialize(data['estimates']),
      weatherInfo: data['weatherInfo'] != null 
        ? WeatherInfo.deserialize(data['weatherInfo']) 
        : null,
    );
  }
}

class TripRoute {
  final String originLocation;
  final double originLat;
  final double originLng;
  final String destinationLocation;
  final double destinationLat;
  final double destinationLng;
  
  TripRoute({
    required this.originLocation,
    required this.originLat,
    required this.originLng,
    required this.destinationLocation,
    required this.destinationLat,
    required this.destinationLng,
  });
  
  Map<String, dynamic> serialize() => {
    'originLocation': originLocation,
    'originLat': originLat,
    'originLng': originLng,
    'destinationLocation': destinationLocation,
    'destinationLat': destinationLat,
    'destinationLng': destinationLng,
  };
  
  factory TripRoute.deserialize(Map<String, dynamic> data) {
    return TripRoute(
      originLocation: data['originLocation'],
      originLat: data['originLat'],
      originLng: data['originLng'],
      destinationLocation: data['destinationLocation'],
      destinationLat: data['destinationLat'],
      destinationLng: data['destinationLng'],
    );
  }
}

class PassengerPreferences {
  final SeatCategory seatCategory;
  final int passengerCount;
  
  PassengerPreferences({
    required this.seatCategory,
    required this.passengerCount,
  });
  
  Map<String, dynamic> serialize() => {
    'seatCategory': seatCategory.name,
    'passengerCount': passengerCount,
  };
  
  factory PassengerPreferences.deserialize(Map<String, dynamic> data) {
    return PassengerPreferences(
      seatCategory: SeatCategory.values.byName(data['seatCategory']),
      passengerCount: data['passengerCount'],
    );
  }
}

class PricingDetails {
  final double fareAmount;
  final String currency;
  final double? discountApplied;
  
  PricingDetails({
    required this.fareAmount,
    this.currency = 'UGX',
    this.discountApplied,
  });
  
  double get finalAmount => fareAmount - (discountApplied ?? 0);
  
  Map<String, dynamic> serialize() => {
    'fareAmount': fareAmount,
    'currency': currency,
    'discountApplied': discountApplied,
  };
  
  factory PricingDetails.deserialize(Map<String, dynamic> data) {
    return PricingDetails(
      fareAmount: data['fareAmount'],
      currency: data['currency'] ?? 'UGX',
      discountApplied: data['discountApplied'],
    );
  }
}

class TripEstimates {
  final int durationMinutes;
  final double distanceKm;
  final DateTime? expectedArrival;
  
  TripEstimates({
    required this.durationMinutes,
    required this.distanceKm,
    this.expectedArrival,
  });
  
  Map<String, dynamic> serialize() => {
    'durationMinutes': durationMinutes,
    'distanceKm': distanceKm,
    'expectedArrival': expectedArrival?.millisecondsSinceEpoch,
  };
  
  factory TripEstimates.deserialize(Map<String, dynamic> data) {
    return TripEstimates(
      durationMinutes: data['durationMinutes'],
      distanceKm: data['distanceKm'],
      expectedArrival: data['expectedArrival'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(data['expectedArrival']) 
        : null,
    );
  }
}

class WeatherInfo {
  final String condition;
  final double temperatureCelsius;
  final double windSpeedKmh;
  final bool isSafeForFlight;
  
  WeatherInfo({
    required this.condition,
    required this.temperatureCelsius,
    required this.windSpeedKmh,
    required this.isSafeForFlight,
  });
  
  Map<String, dynamic> serialize() => {
    'condition': condition,
    'temperatureCelsius': temperatureCelsius,
    'windSpeedKmh': windSpeedKmh,
    'isSafeForFlight': isSafeForFlight,
  };
  
  factory WeatherInfo.deserialize(Map<String, dynamic> data) {
    return WeatherInfo(
      condition: data['condition'],
      temperatureCelsius: data['temperatureCelsius'],
      windSpeedKmh: data['windSpeedKmh'],
      isSafeForFlight: data['isSafeForFlight'],
    );
  }
}

enum SeatCategory {
  standard,
  windowView,
  quietZone,
  extraLegroom,
}

enum TransactionMethod {
  mtnMobileMoney,
  airtelMoney,
  cashOnCompletion,
  creditCard,
}

enum ReservationState {
  awaitingConfirmation,
  confirmed,
  pilotEnroute,
  tripInProgress,
  tripCompleted,
  cancelled,
}
