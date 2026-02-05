/// Drone pilot credentials and statistics
class PilotCredentials {
  final String credentialId;
  final String linkedAccountId;
  final String pilotFullName;
  final String civilAviationLicense;
  final int yearsOfExperience;
  final PilotStatistics stats;
  final String? assignedDroneId;
  final AvailabilityStatus currentStatus;
  final String? photoUrl;
  final EarningsRecord earnings;
  
  PilotCredentials({
    required this.credentialId,
    required this.linkedAccountId,
    required this.pilotFullName,
    required this.civilAviationLicense,
    required this.yearsOfExperience,
    required this.stats,
    this.assignedDroneId,
    required this.currentStatus,
    this.photoUrl,
    required this.earnings,
  });
  
  Map<String, dynamic> serialize() => {
    'credentialId': credentialId,
    'linkedAccountId': linkedAccountId,
    'pilotFullName': pilotFullName,
    'civilAviationLicense': civilAviationLicense,
    'yearsOfExperience': yearsOfExperience,
    'stats': stats.serialize(),
    'assignedDroneId': assignedDroneId,
    'currentStatus': currentStatus.name,
    'photoUrl': photoUrl,
    'earnings': earnings.serialize(),
  };
  
  factory PilotCredentials.deserialize(Map<String, dynamic> data) {
    return PilotCredentials(
      credentialId: data['credentialId'],
      linkedAccountId: data['linkedAccountId'],
      pilotFullName: data['pilotFullName'],
      civilAviationLicense: data['civilAviationLicense'],
      yearsOfExperience: data['yearsOfExperience'],
      stats: PilotStatistics.deserialize(data['stats']),
      assignedDroneId: data['assignedDroneId'],
      currentStatus: AvailabilityStatus.values.byName(data['currentStatus']),
      photoUrl: data['photoUrl'],
      earnings: EarningsRecord.deserialize(data['earnings']),
    );
  }
}

class PilotStatistics {
  final double customerRating;
  final int completedMissions;
  final int hoursFlown;
  
  PilotStatistics({
    required this.customerRating,
    required this.completedMissions,
    required this.hoursFlown,
  });
  
  Map<String, dynamic> serialize() => {
    'customerRating': customerRating,
    'completedMissions': completedMissions,
    'hoursFlown': hoursFlown,
  };
  
  factory PilotStatistics.deserialize(Map<String, dynamic> data) {
    return PilotStatistics(
      customerRating: data['customerRating'],
      completedMissions: data['completedMissions'],
      hoursFlown: data['hoursFlown'],
    );
  }
}

class EarningsRecord {
  final double totalAmount;
  final double currentMonthAmount;
  final String currencyCode;
  
  EarningsRecord({
    required this.totalAmount,
    required this.currentMonthAmount,
    this.currencyCode = 'UGX',
  });
  
  Map<String, dynamic> serialize() => {
    'totalAmount': totalAmount,
    'currentMonthAmount': currentMonthAmount,
    'currencyCode': currencyCode,
  };
  
  factory EarningsRecord.deserialize(Map<String, dynamic> data) {
    return EarningsRecord(
      totalAmount: data['totalAmount'],
      currentMonthAmount: data['currentMonthAmount'],
      currencyCode: data['currencyCode'] ?? 'UGX',
    );
  }
}

enum AvailabilityStatus {
  readyForFlight,
  currentlyFlying,
  offline,
  onBreak,
}
