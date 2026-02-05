import '../models/pilot_credentials.dart';
import 'package:uuid/uuid.dart';

/// Service for managing pilot operations
class PilotOperationsService {
  static final PilotOperationsService _singleton = PilotOperationsService._internal();
  factory PilotOperationsService() => _singleton;
  PilotOperationsService._internal();
  
  final _uuid = const Uuid();
  final List<PilotCredentials> _pilots = [];
  
  /// Register a new pilot
  Future<PilotCredentials> registerPilot({
    required String linkedAccountId,
    required String pilotFullName,
    required String civilAviationLicense,
    required int yearsOfExperience,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final pilot = PilotCredentials(
      credentialId: _uuid.v4(),
      linkedAccountId: linkedAccountId,
      pilotFullName: pilotFullName,
      civilAviationLicense: civilAviationLicense,
      yearsOfExperience: yearsOfExperience,
      stats: PilotStatistics(
        customerRating: 0.0,
        completedMissions: 0,
        hoursFlown: 0,
      ),
      currentStatus: AvailabilityStatus.readyForFlight,
      earnings: EarningsRecord(
        totalAmount: 0.0,
        currentMonthAmount: 0.0,
      ),
    );
    
    _pilots.add(pilot);
    return pilot;
  }
  
  /// Get pilot by account ID
  Future<PilotCredentials?> fetchPilotByAccountId(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _pilots.firstWhere((p) => p.linkedAccountId == accountId);
    } catch (e) {
      return null;
    }
  }
  
  /// Get pilot by credential ID
  Future<PilotCredentials?> fetchPilotById(String credentialId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _pilots.firstWhere((p) => p.credentialId == credentialId);
    } catch (e) {
      return null;
    }
  }
  
  /// Update pilot availability status
  Future<void> updateAvailabilityStatus(String credentialId, AvailabilityStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _pilots.indexWhere((p) => p.credentialId == credentialId);
    if (index != -1) {
      final pilot = _pilots[index];
      _pilots[index] = PilotCredentials(
        credentialId: pilot.credentialId,
        linkedAccountId: pilot.linkedAccountId,
        pilotFullName: pilot.pilotFullName,
        civilAviationLicense: pilot.civilAviationLicense,
        yearsOfExperience: pilot.yearsOfExperience,
        stats: pilot.stats,
        assignedDroneId: pilot.assignedDroneId,
        currentStatus: status,
        photoUrl: pilot.photoUrl,
        earnings: pilot.earnings,
      );
    }
  }
  
  /// Update pilot earnings after completed trip
  Future<void> updateEarnings(String credentialId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _pilots.indexWhere((p) => p.credentialId == credentialId);
    if (index != -1) {
      final pilot = _pilots[index];
      _pilots[index] = PilotCredentials(
        credentialId: pilot.credentialId,
        linkedAccountId: pilot.linkedAccountId,
        pilotFullName: pilot.pilotFullName,
        civilAviationLicense: pilot.civilAviationLicense,
        yearsOfExperience: pilot.yearsOfExperience,
        stats: pilot.stats,
        assignedDroneId: pilot.assignedDroneId,
        currentStatus: pilot.currentStatus,
        photoUrl: pilot.photoUrl,
        earnings: EarningsRecord(
          totalAmount: pilot.earnings.totalAmount + amount,
          currentMonthAmount: pilot.earnings.currentMonthAmount + amount,
        ),
      );
    }
  }
  
  /// Get all available pilots
  Future<List<PilotCredentials>> fetchAvailablePilots() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _pilots.where((p) => p.currentStatus == AvailabilityStatus.readyForFlight).toList();
  }
  
  /// Initialize mock pilots
  void initializeMockPilots() {
    _pilots.clear();
    _pilots.addAll([
      PilotCredentials(
        credentialId: _uuid.v4(),
        linkedAccountId: 'mock-account-1',
        pilotFullName: 'David Mukasa',
        civilAviationLicense: 'UG-CPL-2019-0234',
        yearsOfExperience: 5,
        stats: PilotStatistics(
          customerRating: 4.8,
          completedMissions: 342,
          hoursFlown: 1250,
        ),
        currentStatus: AvailabilityStatus.readyForFlight,
        earnings: EarningsRecord(
          totalAmount: 45000000,
          currentMonthAmount: 3500000,
        ),
      ),
      PilotCredentials(
        credentialId: _uuid.v4(),
        linkedAccountId: 'mock-account-2',
        pilotFullName: 'Sarah Nakato',
        civilAviationLicense: 'UG-CPL-2020-0567',
        yearsOfExperience: 3,
        stats: PilotStatistics(
          customerRating: 4.9,
          completedMissions: 218,
          hoursFlown: 890,
        ),
        currentStatus: AvailabilityStatus.readyForFlight,
        earnings: EarningsRecord(
          totalAmount: 28000000,
          currentMonthAmount: 2800000,
        ),
      ),
    ]);
  }
}
