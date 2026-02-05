// App Constants
class AppConstants {
  // App Info
  static const String appName = 'Fly Express';
  static const String appTagline = 'Your Sky Ride Awaits';
  
  // Uganda Phone Format
  static const String phonePrefix = '+256';
  static const List<String> ugandaPhoneCodes = [
    '70', '75', '76', '77', '78', '39', // MTN
    '74', '20', // Airtel
    '71', '31', // Africell
  ];
  
  // Currency
  static const String currency = 'UGX';
  static const String currencySymbol = 'UGX';
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'MTN Mobile Money',
    'Airtel Money',
    'Cash on Delivery',
    'Credit/Debit Card',
  ];
  
  // Uganda Cities
  static const List<String> ugandaCities = [
    'Kampala',
    'Entebbe',
    'Jinja',
    'Mbarara',
    'Gulu',
    'Lira',
    'Hoima',
    'Mbale',
    'Kasese',
    'Fort Portal',
  ];
  
  // Seat Types
  static const List<String> seatTypes = [
    'Standard',
    'Window',
    'Quiet Zone',
    'Extra Legroom',
  ];
  
  // Drone Models
  static const List<String> droneModels = [
    'SkyFlyer X1',
    'AeroTaxi Pro',
    'CloudRider 3000',
    'UgandaAir Express',
  ];
  
  // Booking Status
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  
  // User Roles
  static const String roleUser = 'user';
  static const String rolePilot = 'pilot';
  static const String roleAdmin = 'admin';
}
