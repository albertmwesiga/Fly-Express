import 'package:flutter/foundation.dart';
import '../models/trip_reservation.dart';
import '../services/reservation_management_service.dart';

/// Handles trip booking operations and state
class BookingController with ChangeNotifier {
  final ReservationManagementService _reservationManager = ReservationManagementService();
  
  List<TripReservation> _customerBookings = [];
  List<TripReservation> _pilotAssignments = [];
  TripReservation? _selectedBooking;
  bool _operationInProgress = false;
  String? _errorDetails;
  
  List<TripReservation> get customerBookings => _customerBookings;
  List<TripReservation> get pilotAssignments => _pilotAssignments;
  TripReservation? get selectedBooking => _selectedBooking;
  bool get operationInProgress => _operationInProgress;
  String? get errorDetails => _errorDetails;
  
  Future<TripReservation?> submitNewBooking({
    required String customerId,
    required String vehicleId,
    required TripRoute route,
    required DateTime scheduledDeparture,
    required PassengerPreferences preferences,
    required TransactionMethod paymentMethod,
  }) async {
    _operationInProgress = true;
    _errorDetails = null;
    notifyListeners();
    
    try {
      final booking = await _reservationManager.createReservation(
        customerId: customerId,
        vehicleId: vehicleId,
        route: route,
        scheduledDeparture: scheduledDeparture,
        preferences: preferences,
        paymentMethod: paymentMethod,
      );
      
      _selectedBooking = booking;
      _customerBookings.add(booking);
      _operationInProgress = false;
      notifyListeners();
      return booking;
    } catch (error) {
      _errorDetails = error.toString();
      _operationInProgress = false;
      notifyListeners();
      return null;
    }
  }
  
  Future<void> retrieveCustomerBookings(String customerId) async {
    _operationInProgress = true;
    notifyListeners();
    
    try {
      _customerBookings = await _reservationManager.fetchCustomerReservations(customerId);
      _operationInProgress = false;
      notifyListeners();
    } catch (error) {
      _errorDetails = error.toString();
      _operationInProgress = false;
      notifyListeners();
    }
  }
  
  Future<void> retrievePilotAssignments(String pilotId) async {
    _operationInProgress = true;
    notifyListeners();
    
    try {
      _pilotAssignments = await _reservationManager.fetchPilotReservations(pilotId);
      _operationInProgress = false;
      notifyListeners();
    } catch (error) {
      _errorDetails = error.toString();
      _operationInProgress = false;
      notifyListeners();
    }
  }
  
  Future<bool> modifyBookingStatus(String bookingId, ReservationState newStatus) async {
    _operationInProgress = true;
    notifyListeners();
    
    try {
      final updatedBooking = await _reservationManager.updateReservationState(bookingId, newStatus);
      
      final customerIdx = _customerBookings.indexWhere((b) => b.reservationId == bookingId);
      if (customerIdx != -1) {
        _customerBookings[customerIdx] = updatedBooking;
      }
      
      final pilotIdx = _pilotAssignments.indexWhere((b) => b.reservationId == bookingId);
      if (pilotIdx != -1) {
        _pilotAssignments[pilotIdx] = updatedBooking;
      }
      
      if (_selectedBooking?.reservationId == bookingId) {
        _selectedBooking = updatedBooking;
      }
      
      _operationInProgress = false;
      notifyListeners();
      return true;
    } catch (error) {
      _errorDetails = error.toString();
      _operationInProgress = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> linkPilotToBooking(String bookingId, String pilotId) async {
    try {
      await _reservationManager.assignPilotToReservation(bookingId, pilotId);
      notifyListeners();
    } catch (error) {
      _errorDetails = error.toString();
      notifyListeners();
    }
  }
}
