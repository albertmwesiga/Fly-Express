import 'package:flutter/foundation.dart';
import '../models/account_profile.dart';
import '../services/authentication_service.dart';

/// Manages session state for authenticated users
class SessionController with ChangeNotifier {
  final AuthenticationService _authenticationService = AuthenticationService();
  
  AccountProfile? _loggedInProfile;
  bool _processingRequest = false;
  String? _lastError;
  
  AccountProfile? get loggedInProfile => _loggedInProfile;
  bool get hasActiveSession => _loggedInProfile != null;
  bool get processingRequest => _processingRequest;
  String? get lastError => _lastError;
  
  Future<void> verifyExistingSession() async {
    _loggedInProfile = _authenticationService.activeAccount;
    notifyListeners();
  }
  
  Future<bool> performRegistration({
    required String fullName,
    required String emailAddress,
    required String ugandaPhone,
    required AccountType accountType,
    CorporateDetails? corporateInfo,
  }) async {
    _processingRequest = true;
    _lastError = null;
    notifyListeners();
    
    try {
      _loggedInProfile = await _authenticationService.registerAccount(
        fullName: fullName,
        emailAddress: emailAddress,
        ugandaPhone: ugandaPhone,
        accountType: accountType,
        corporateInfo: corporateInfo,
      );
      _processingRequest = false;
      notifyListeners();
      return true;
    } catch (error) {
      _lastError = error.toString();
      _processingRequest = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> performLogin(String identifier, String secret) async {
    _processingRequest = true;
    _lastError = null;
    notifyListeners();
    
    try {
      _loggedInProfile = await _authenticationService.loginWithCredentials(
        phoneOrEmail: identifier,
        password: secret,
      );
      _processingRequest = false;
      notifyListeners();
      return true;
    } catch (error) {
      _lastError = error.toString();
      _processingRequest = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> terminateSession() async {
    await _authenticationService.logout();
    _loggedInProfile = null;
    notifyListeners();
  }
  
  void dismissError() {
    _lastError = null;
    notifyListeners();
  }
}
