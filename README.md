# Fly Express - Drone Taxi Service

A high-fidelity Flutter prototype for a drone taxi service tailored for Uganda.

## Features

### User Features
- Account registration/login with Uganda-specific details
- Browse available drones with live tracking
- Seat selection (window, quiet zone, extra legroom)
- Pre-booking and scheduling
- In-app chat with pilot
- Payment options (Mobile Money, cash on delivery)
- Office/company subscription accounts

### Pilot Features
- Pilot registration and profile management
- Dashboard to manage flights and bookings
- Live tracking integration
- In-app chat with users
- Earnings tracking

### Admin Features
- Dashboard for overseeing users, pilots, drones, bookings
- Manage pricing, fleet availability, weather-based routing
- Analytics on bookings, revenue, user feedback

## Technical Stack
- **Framework**: Flutter (iOS/Android)
- **State Management**: Provider
- **Maps**: Google Maps
- **Mock APIs**: Weather, Payments
- **Storage**: Shared Preferences

## Project Structure
```
lib/
├── main.dart
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── services/        # API services
├── widgets/         # Reusable widgets
├── utils/           # Utility functions
└── constants/       # App constants
```

## Setup

1. Install Flutter SDK
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Mock Data
- Uganda locations: Kampala, Entebbe, Jinja, Mbarara
- Currency: UGX (Uganda Shillings)
- Mobile Money: MTN Mobile Money, Airtel Money

## License
MIT