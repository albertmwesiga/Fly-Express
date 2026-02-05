# API Documentation - Fly Express

This document describes the mock API structure used in the Fly Express prototype.

## Base Structure

All services return `Future<T>` to simulate async API calls. In a production environment, these would be replaced with actual HTTP requests.

## Authentication Service

### Register Account
```dart
Future<AccountProfile> registerAccount({
  required String fullName,
  required String emailAddress,
  required String ugandaPhone,
  required AccountType accountType,
  CorporateDetails? corporateInfo,
})
```

**Validation:**
- Phone must start with +256
- Phone must be exactly 13 characters
- Email must contain @

**Returns:** AccountProfile object

### Login
```dart
Future<AccountProfile> loginWithCredentials({
  required String phoneOrEmail,
  required String password,
})
```

**Returns:** AccountProfile object

### Logout
```dart
Future<void> logout()
```

## Fleet Management Service

### Fetch Available Vehicles
```dart
Future<List<AerialVehicle>> fetchAvailableVehicles()
```

**Returns:** List of vehicles with status 'standingBy' and available seats

### Fetch Vehicle by ID
```dart
Future<AerialVehicle?> fetchVehicleById(String vehicleId)
```

### Update Vehicle Position
```dart
Future<void> updateVehiclePosition(String vehicleId, double lat, double lng)
```

**Parameters:**
- vehicleId: Unique vehicle identifier
- lat: Latitude coordinate
- lng: Longitude coordinate

### Assign Pilot to Vehicle
```dart
Future<void> assignPilotToVehicle(String vehicleId, String pilotId)
```

## Reservation Management Service

### Create Reservation
```dart
Future<TripReservation> createReservation({
  required String customerId,
  required String vehicleId,
  required TripRoute route,
  required DateTime scheduledDeparture,
  required PassengerPreferences preferences,
  required TransactionMethod paymentMethod,
})
```

**Pricing Calculation:**
```
Base Fare: 50,000 UGX
Per Km Rate: 3,000 UGX

Category Multipliers:
- Standard: 1.0x
- Window View: 1.2x
- Quiet Zone: 1.3x
- Extra Legroom: 1.5x

Final Price = (Base + Distance * Rate) * Multiplier * PassengerCount
```

**Distance Calculation:**
Uses Haversine formula for accurate geographic distance

### Fetch Customer Reservations
```dart
Future<List<TripReservation>> fetchCustomerReservations(String customerId)
```

### Fetch Pilot Reservations
```dart
Future<List<TripReservation>> fetchPilotReservations(String pilotId)
```

### Update Reservation State
```dart
Future<TripReservation> updateReservationState(
  String reservationId,
  ReservationState newState,
)
```

**Available States:**
- awaitingConfirmation
- confirmed
- pilotEnroute
- tripInProgress
- tripCompleted
- cancelled

### Assign Pilot to Reservation
```dart
Future<void> assignPilotToReservation(String reservationId, String pilotId)
```

## Messaging Service

### Send Message
```dart
Future<ConversationMessage> sendMessage({
  required String fromAccountId,
  required String toAccountId,
  required String textContent,
  String? relatedReservationId,
  MessageType messageType = MessageType.text,
})
```

### Fetch Conversation
```dart
Future<List<ConversationMessage>> fetchConversation({
  required String account1Id,
  required String account2Id,
  String? reservationId,
})
```

**Returns:** Messages sorted by timestamp (ascending)

### Mark Messages as Read
```dart
Future<void> markMessagesAsRead(List<String> messageIds)
```

### Get Unread Count
```dart
Future<int> getUnreadCount(String accountId)
```

### Fetch All Conversations
```dart
Future<Map<String, List<ConversationMessage>>> fetchAllConversations(String accountId)
```

**Returns:** Map with otherUserId as key and message list as value

## Pilot Operations Service

### Register Pilot
```dart
Future<PilotCredentials> registerPilot({
  required String linkedAccountId,
  required String pilotFullName,
  required String civilAviationLicense,
  required int yearsOfExperience,
})
```

### Fetch Pilot by Account ID
```dart
Future<PilotCredentials?> fetchPilotByAccountId(String accountId)
```

### Fetch Pilot by ID
```dart
Future<PilotCredentials?> fetchPilotById(String credentialId)
```

### Update Availability Status
```dart
Future<void> updateAvailabilityStatus(
  String credentialId,
  AvailabilityStatus status,
)
```

**Available Status:**
- readyForFlight
- currentlyFlying
- offline
- onBreak

### Update Earnings
```dart
Future<void> updateEarnings(String credentialId, double amount)
```

### Fetch Available Pilots
```dart
Future<List<PilotCredentials>> fetchAvailablePilots()
```

## Data Models

### AccountProfile
```dart
{
  accountId: String,
  fullName: String,
  emailAddress: String,
  ugandaPhoneNumber: String,
  accountType: enum,
  avatarUrl: String?,
  registrationDate: DateTime,
  corporateInfo: CorporateDetails?
}
```

### AerialVehicle
```dart
{
  vehicleId: String,
  modelDesignation: String,
  registryCode: String,
  seatingConfig: {
    maximumCapacity: int,
    openSeats: int
  },
  currentPosition: {
    latitudeDegrees: double,
    longitudeDegrees: double,
    altitudeMeters: double?
  },
  operationalState: enum,
  operatorId: String?,
  activeReservationId: String?,
  powerStatus: {
    chargePercentage: double,
    estimatedRangeKm: int
  }
}
```

### TripReservation
```dart
{
  reservationId: String,
  customerId: String,
  vehicleId: String,
  assignedPilotId: String?,
  route: {
    originLocation: String,
    originLat: double,
    originLng: double,
    destinationLocation: String,
    destinationLat: double,
    destinationLng: double
  },
  scheduledDeparture: DateTime,
  preferences: {
    seatCategory: enum,
    passengerCount: int
  },
  pricing: {
    fareAmount: double,
    currency: String,
    discountApplied: double?
  },
  paymentMethod: enum,
  currentState: enum,
  createdTimestamp: DateTime,
  finishedTimestamp: DateTime?,
  estimates: {
    durationMinutes: int,
    distanceKm: double,
    expectedArrival: DateTime?
  },
  weatherInfo: {
    condition: String,
    temperatureCelsius: double,
    windSpeedKmh: double,
    isSafeForFlight: bool
  }?
}
```

## Error Handling

All services throw exceptions on error:
```dart
try {
  final result = await service.someMethod();
} catch (e) {
  // Handle error
  print('Error: $e');
}
```

## Mock Data Initialization

Initialize mock data on app start:
```dart
void initializeMockData() {
  FleetManagementService().initializeMockFleet();
  PilotOperationsService().initializeMockPilots();
}
```

## Future API Integration

To integrate real APIs:

1. Create API client service
2. Replace mock service implementations
3. Add proper error handling
4. Implement request/response interceptors
5. Add authentication headers
6. Handle network connectivity
7. Implement retry logic

Example:
```dart
class ApiClient {
  final Dio _dio;
  
  Future<T> get<T>(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
```
