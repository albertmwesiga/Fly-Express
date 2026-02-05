# Development Guide - Fly Express

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── constants/
│   ├── app_theme.dart                 # Color scheme and text styles
│   └── app_constants.dart             # App-wide constants
├── models/
│   ├── account_profile.dart           # User account data model
│   ├── pilot_credentials.dart         # Pilot information model
│   ├── aerial_vehicle.dart            # Drone/vehicle model
│   ├── trip_reservation.dart          # Booking model
│   └── conversation_message.dart      # Chat message model
├── services/
│   ├── authentication_service.dart    # Auth operations
│   ├── fleet_management_service.dart  # Vehicle operations
│   ├── reservation_management_service.dart # Booking operations
│   ├── messaging_service.dart         # Chat operations
│   └── pilot_operations_service.dart  # Pilot management
├── providers/
│   ├── session_controller.dart        # Auth state management
│   ├── vehicle_fleet_controller.dart  # Fleet state management
│   ├── booking_controller.dart        # Booking state management
│   └── communication_controller.dart  # Chat state management
└── screens/
    ├── splash_screen.dart             # Initial loading screen
    ├── auth/
    │   ├── login_screen.dart          # Login interface
    │   └── registration_screen.dart   # Sign-up wizard
    ├── user/
    │   └── user_home_screen.dart      # User dashboard
    ├── pilot/
    │   └── pilot_dashboard_screen.dart # Pilot interface
    └── admin/
        └── admin_dashboard_screen.dart # Admin panel
```

## Running the Application

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio

### Installation Steps

1. **Clone the repository**
```bash
git clone https://github.com/albertmwesiga/Fly-Express.git
cd Fly-Express
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Available Demo Accounts

The app includes quick demo access for testing:

**Regular User:**
- Any email/phone
- Any password (minimum 6 characters)

**Pilot:**
- Access through demo button in login screen

**Admin:**
- Access through demo button in login screen

## Development Workflow

### Adding New Features

1. **Create Model** (if needed)
   - Add to `lib/models/`
   - Implement serialization methods
   - Use unique naming conventions

2. **Create Service** (if needed)
   - Add to `lib/services/`
   - Implement async operations
   - Add mock data for testing

3. **Create Provider** (if needed)
   - Add to `lib/providers/`
   - Extend `ChangeNotifier`
   - Manage state and notify listeners

4. **Create Screen**
   - Add to appropriate `lib/screens/` subdirectory
   - Use existing constants for styling
   - Implement responsive design

### Code Style Guidelines

1. **Naming Conventions**
   - Classes: PascalCase
   - Variables/Functions: camelCase
   - Constants: camelCase with const keyword
   - Private members: _leadingUnderscore

2. **File Organization**
   - One main class per file
   - Helper classes in same file with underscore prefix
   - Keep files under 500 lines when possible

3. **State Management**
   - Use `Consumer` widgets for UI updates
   - Use `context.read()` for one-time operations
   - Always dispose controllers in stateful widgets

4. **Error Handling**
   - Use try-catch in async operations
   - Show user-friendly error messages
   - Log errors for debugging

## Testing

### Manual Testing Checklist

- [ ] User can register with Uganda phone number
- [ ] User can login with credentials
- [ ] User can view available drones
- [ ] Drone information displays correctly
- [ ] User can navigate between tabs
- [ ] Logout functionality works
- [ ] Pilot dashboard displays
- [ ] Admin dashboard displays

### Mock Data

The app uses mock data for:
- Uganda city coordinates
- Drone fleet information
- Pilot credentials
- Weather conditions
- Payment transactions

All mock data is generated in the service layer for easy modification.

## Customization

### Changing Colors

Edit `lib/constants/app_theme.dart`:
```dart
class AppColors {
  static const Color primary = Color(0xFF2196F3);  // Change here
  static const Color accent = Color(0xFFFF9800);   // Change here
  // ...
}
```

### Adding Uganda Cities

Edit `lib/constants/app_constants.dart`:
```dart
static const List<String> ugandaCities = [
  'Kampala',
  'Entebbe',
  // Add more cities...
];
```

### Modifying Pricing

Edit `lib/services/reservation_management_service.dart`:
```dart
double _calculateBasePrice(double distanceKm, SeatCategory category) {
  double baseFare = 50000;      // Modify base fare
  double perKmRate = 3000;      // Modify per km rate
  // ...
}
```

## Deployment

### Android

1. Configure app signing
2. Build release APK:
```bash
flutter build apk --release
```

### iOS

1. Configure certificates in Xcode
2. Build release IPA:
```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## Troubleshooting

### Common Issues

**Issue: Dependencies not resolving**
```bash
flutter clean
flutter pub get
```

**Issue: Build errors**
```bash
flutter doctor
# Fix any issues reported
```

**Issue: Hot reload not working**
- Restart the app with `r` in terminal
- Or stop and run `flutter run` again

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - See LICENSE file for details
