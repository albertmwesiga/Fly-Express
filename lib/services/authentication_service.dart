import '../models/account_profile.dart';
import 'package:uuid/uuid.dart';

/// Mock authentication service for Fly Express
class AuthenticationService {
  static final AuthenticationService _singleton = AuthenticationService._internal();
  factory AuthenticationService() => _singleton;
  AuthenticationService._internal();
  
  final _uuid = const Uuid();
  AccountProfile? _activeAccount;
  
  AccountProfile? get activeAccount => _activeAccount;
  bool get hasActiveSession => _activeAccount != null;
  
  /// Register new account with Uganda-specific details
  Future<AccountProfile> registerAccount({
    required String fullName,
    required String emailAddress,
    required String ugandaPhone,
    required AccountType accountType,
    CorporateDetails? corporateInfo,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Validate Uganda phone format
    if (!_isValidUgandaPhone(ugandaPhone)) {
      throw Exception('Invalid Uganda phone number format');
    }
    
    final account = AccountProfile(
      accountId: _uuid.v4(),
      fullName: fullName,
      emailAddress: emailAddress,
      ugandaPhoneNumber: ugandaPhone,
      accountType: accountType,
      registrationDate: DateTime.now(),
      corporateInfo: corporateInfo,
    );
    
    _activeAccount = account;
    return account;
  }
  
  /// Login with credentials
  Future<AccountProfile> loginWithCredentials({
    required String phoneOrEmail,
    required String password,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock login - in real app, validate with backend
    _activeAccount = AccountProfile(
      accountId: _uuid.v4(),
      fullName: 'Demo User',
      emailAddress: phoneOrEmail.contains('@') ? phoneOrEmail : 'demo@flyexpress.ug',
      ugandaPhoneNumber: phoneOrEmail.startsWith('+256') ? phoneOrEmail : '+256701234567',
      accountType: AccountType.regularUser,
      registrationDate: DateTime.now().subtract(const Duration(days: 30)),
    );
    
    return _activeAccount!;
  }
  
  /// Logout current session
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _activeAccount = null;
  }
  
  bool _isValidUgandaPhone(String phone) {
    // Check if starts with +256 and has correct length
    if (!phone.startsWith('+256')) return false;
    final digits = phone.substring(4);
    return digits.length == 9 && int.tryParse(digits) != null;
  }
}
