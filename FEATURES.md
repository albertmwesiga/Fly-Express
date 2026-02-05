# Fly Express - Feature Documentation

## Implemented Features

### Core Architecture
- **Custom State Management**: Unique provider-based controllers with distinct naming conventions
  - `SessionController`: Manages authentication state
  - `VehicleFleetController`: Controls aerial vehicle operations
  - `BookingController`: Handles trip reservations
  - `CommunicationController`: Manages in-app messaging

### Data Models
All models use custom serialization methods and unique field names:
- `AccountProfile`: User accounts with Uganda-specific fields
- `PilotCredentials`: Pilot information with aviation licenses
- `AerialVehicle`: Drone fleet with seating configurations
- `TripReservation`: Booking system with weather integration
- `ConversationMessage`: Chat system for user-pilot communication

### Services Layer
Mock services simulating real API behavior:
- `AuthenticationService`: User registration and login
- `FleetManagementService`: Drone fleet operations
- `ReservationManagementService`: Booking management with pricing calculations
- `MessagingService`: In-app chat functionality
- `PilotOperationsService`: Pilot management and earnings tracking

### User Interface

#### Authentication Screens
- **Splash Screen**: Custom animated branding with drone pattern painter
- **Login Screen**: Multi-step authentication with demo access
- **Registration Screen**: Three-step wizard with account type selection

#### User Dashboard
- Browse available drones with real-time fleet status
- View seating capacity and battery levels
- Quick action buttons for booking
- Trip history management
- Account management

#### Pilot Dashboard
- Flight statistics and earnings overview
- Upcoming flight management
- Performance metrics display

#### Admin Dashboard
- Platform-wide metrics overview
- User and pilot management access
- Fleet analytics

## Uganda-Specific Features

### Phone Number Validation
- Enforces +256 country code
- Validates Uganda mobile number formats
- Supports major carriers (MTN, Airtel, Africell)

### Payment Methods
- MTN Mobile Money integration (mock)
- Airtel Money support (mock)
- Cash on delivery option
- Credit card processing (mock)

### Locations
Pre-configured Uganda cities:
- Kampala (Capital)
- Entebbe (Airport city)
- Jinja
- Mbarara
- Gulu
- Lira
- And more...

### Currency
- UGX (Uganda Shillings) throughout
- Pricing calculated based on distance and seat category

## Seat Categories
- **Standard**: Basic seating
- **Window View**: Premium window seats
- **Quiet Zone**: Silent cabin area
- **Extra Legroom**: Spacious seating

## Technical Implementation

### State Management Pattern
Uses Provider package with custom controller classes that:
- Manage asynchronous operations
- Handle error states
- Provide loading indicators
- Notify listeners on state changes

### Mock Data System
- Realistic Uganda coordinates for drone locations
- Simulated weather conditions
- Distance-based pricing calculations
- Haversine formula for geo-distance computation

### UI/UX Design
- Custom color scheme with primary and accent colors
- Consistent spacing using dimension constants
- Material Design 3 components
- Gradient backgrounds and shadows
- Custom animations and transitions

## Booking Flow
1. User selects origin and destination
2. System calculates distance and pricing
3. Weather conditions checked
4. Seat selection (type and quantity)
5. Payment method selection
6. Booking confirmation
7. Pilot assignment
8. Real-time tracking

## Communication System
- One-to-one chat between users and pilots
- Booking-specific conversations
- Unread message tracking
- Message read receipts

## Security Features
- Password validation (minimum 6 characters)
- Phone number format validation
- Email format validation
- Corporate account verification

## Offline Capabilities
- Local state caching
- Graceful error handling
- Network status awareness

## Future Enhancements
- Real Google Maps integration
- Actual OpenWeatherMap API
- Real payment gateway integration
- Push notifications
- Live location tracking
- Video chat with pilot
- Multi-language support (English, Luganda, Swahili)
- Loyalty program
- Corporate dashboard
- Advanced analytics
- Flight recording and playback
