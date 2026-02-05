/// Account entity for Fly Express platform
class AccountProfile {
  final String accountId;
  final String fullName;
  final String emailAddress;
  final String ugandaPhoneNumber;
  final AccountType accountType;
  final String? avatarUrl;
  final DateTime registrationDate;
  final CorporateDetails? corporateInfo;
  
  AccountProfile({
    required this.accountId,
    required this.fullName,
    required this.emailAddress,
    required this.ugandaPhoneNumber,
    required this.accountType,
    this.avatarUrl,
    required this.registrationDate,
    this.corporateInfo,
  });
  
  Map<String, dynamic> serialize() => {
    'accountId': accountId,
    'fullName': fullName,
    'emailAddress': emailAddress,
    'ugandaPhoneNumber': ugandaPhoneNumber,
    'accountType': accountType.value,
    'avatarUrl': avatarUrl,
    'registrationDate': registrationDate.millisecondsSinceEpoch,
    'corporateInfo': corporateInfo?.serialize(),
  };
  
  factory AccountProfile.deserialize(Map<String, dynamic> data) {
    return AccountProfile(
      accountId: data['accountId'],
      fullName: data['fullName'],
      emailAddress: data['emailAddress'],
      ugandaPhoneNumber: data['ugandaPhoneNumber'],
      accountType: AccountType.fromValue(data['accountType']),
      avatarUrl: data['avatarUrl'],
      registrationDate: DateTime.fromMillisecondsSinceEpoch(data['registrationDate']),
      corporateInfo: data['corporateInfo'] != null 
        ? CorporateDetails.deserialize(data['corporateInfo']) 
        : null,
    );
  }
}

enum AccountType {
  regularUser('regular_user'),
  flightPilot('flight_pilot'),
  systemAdmin('system_admin');
  
  final String value;
  const AccountType(this.value);
  
  static AccountType fromValue(String val) {
    return AccountType.values.firstWhere((e) => e.value == val);
  }
}

class CorporateDetails {
  final String organizationName;
  final String taxIdentifier;
  final int employeeCount;
  
  CorporateDetails({
    required this.organizationName,
    required this.taxIdentifier,
    required this.employeeCount,
  });
  
  Map<String, dynamic> serialize() => {
    'organizationName': organizationName,
    'taxIdentifier': taxIdentifier,
    'employeeCount': employeeCount,
  };
  
  factory CorporateDetails.deserialize(Map<String, dynamic> data) {
    return CorporateDetails(
      organizationName: data['organizationName'],
      taxIdentifier: data['taxIdentifier'],
      employeeCount: data['employeeCount'],
    );
  }
}
