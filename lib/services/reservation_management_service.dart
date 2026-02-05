import '../models/trip_reservation.dart';
import '../models/aerial_vehicle.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

/// Service for handling trip reservations and bookings
class ReservationManagementService {
  static final ReservationManagementService _singleton = ReservationManagementService._internal();
  factory ReservationManagementService() => _singleton;
  ReservationManagementService._internal();
  
  final _uuid = const Uuid();
  final List<TripReservation> _reservations = [];
  final _random = math.Random();
  
  /// Create new trip reservation
  Future<TripReservation> createReservation({
    required String customerId,
    required String vehicleId,
    required TripRoute route,
    required DateTime scheduledDeparture,
    required PassengerPreferences preferences,
    required TransactionMethod paymentMethod,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Calculate distance and pricing
    final distance = _calculateDistance(
      route.originLat, route.originLng,
      route.destinationLat, route.destinationLng,
    );
    
    final basePrice = _calculateBasePrice(distance, preferences.seatCategory);
    final totalPrice = basePrice * preferences.passengerCount;
    
    final reservation = TripReservation(
      reservationId: _uuid.v4(),
      customerId: customerId,
      vehicleId: vehicleId,
      route: route,
      scheduledDeparture: scheduledDeparture,
      preferences: preferences,
      pricing: PricingDetails(fareAmount: totalPrice),
      paymentMethod: paymentMethod,
      currentState: ReservationState.awaitingConfirmation,
      createdTimestamp: DateTime.now(),
      estimates: TripEstimates(
        durationMinutes: (distance / 2.5).round(), // Assuming 150 km/h average speed
        distanceKm: distance,
        expectedArrival: scheduledDeparture.add(Duration(minutes: (distance / 2.5).round())),
      ),
      weatherInfo: _generateMockWeather(),
    );
    
    _reservations.add(reservation);
    return reservation;
  }
  
  /// Get all reservations for a customer
  Future<List<TripReservation>> fetchCustomerReservations(String customerId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _reservations.where((r) => r.customerId == customerId).toList();
  }
  
  /// Get all reservations for a pilot
  Future<List<TripReservation>> fetchPilotReservations(String pilotId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _reservations.where((r) => r.assignedPilotId == pilotId).toList();
  }
  
  /// Update reservation state
  Future<TripReservation> updateReservationState(
    String reservationId,
    ReservationState newState,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _reservations.indexWhere((r) => r.reservationId == reservationId);
    if (index == -1) throw Exception('Reservation not found');
    
    final current = _reservations[index];
    final updated = TripReservation(
      reservationId: current.reservationId,
      customerId: current.customerId,
      vehicleId: current.vehicleId,
      assignedPilotId: current.assignedPilotId,
      route: current.route,
      scheduledDeparture: current.scheduledDeparture,
      preferences: current.preferences,
      pricing: current.pricing,
      paymentMethod: current.paymentMethod,
      currentState: newState,
      createdTimestamp: current.createdTimestamp,
      finishedTimestamp: newState == ReservationState.tripCompleted 
        ? DateTime.now() 
        : current.finishedTimestamp,
      estimates: current.estimates,
      weatherInfo: current.weatherInfo,
    );
    
    _reservations[index] = updated;
    return updated;
  }
  
  /// Assign pilot to reservation
  Future<void> assignPilotToReservation(String reservationId, String pilotId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _reservations.indexWhere((r) => r.reservationId == reservationId);
    if (index != -1) {
      final current = _reservations[index];
      _reservations[index] = TripReservation(
        reservationId: current.reservationId,
        customerId: current.customerId,
        vehicleId: current.vehicleId,
        assignedPilotId: pilotId,
        route: current.route,
        scheduledDeparture: current.scheduledDeparture,
        preferences: current.preferences,
        pricing: current.pricing,
        paymentMethod: current.paymentMethod,
        currentState: ReservationState.confirmed,
        createdTimestamp: current.createdTimestamp,
        finishedTimestamp: current.finishedTimestamp,
        estimates: current.estimates,
        weatherInfo: current.weatherInfo,
      );
    }
  }
  
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Haversine formula for distance calculation
    const earthRadius = 6371.0; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }
  
  double _toRadians(double degrees) => degrees * math.pi / 180;
  
  double _calculateBasePrice(double distanceKm, SeatCategory category) {
    double baseFare = 50000; // Base fare in UGX
    double perKmRate = 3000; // UGX per km
    
    double categoryMultiplier = switch (category) {
      SeatCategory.standard => 1.0,
      SeatCategory.windowView => 1.2,
      SeatCategory.quietZone => 1.3,
      SeatCategory.extraLegroom => 1.5,
    };
    
    return (baseFare + (distanceKm * perKmRate)) * categoryMultiplier;
  }
  
  WeatherInfo _generateMockWeather() {
    final conditions = ['Clear', 'Partly Cloudy', 'Cloudy', 'Light Rain'];
    return WeatherInfo(
      condition: conditions[_random.nextInt(conditions.length)],
      temperatureCelsius: 22.0 + _random.nextDouble() * 8,
      windSpeedKmh: 5.0 + _random.nextDouble() * 15,
      isSafeForFlight: _random.nextDouble() > 0.2,
    );
  }
}
