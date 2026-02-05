import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/session_controller.dart';
import 'providers/vehicle_fleet_controller.dart';
import 'providers/booking_controller.dart';
import 'providers/communication_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/user_home_screen.dart';
import 'screens/pilot/pilot_dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'constants/app_theme.dart';
import 'models/account_profile.dart';

void main() {
  runApp(const FlyExpressApplication());
}

class FlyExpressApplication extends StatelessWidget {
  const FlyExpressApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionController()),
        ChangeNotifierProvider(create: (_) => VehicleFleetController()),
        ChangeNotifierProvider(create: (_) => BookingController()),
        ChangeNotifierProvider(create: (_) => CommunicationController()),
      ],
      child: MaterialApp(
        title: 'Fly Express - Uganda Drone Taxi',
        debugShowCheckedModeBanner: false,
        theme: _buildAppTheme(),
        home: const RootNavigationHandler(),
      ),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        margin: const EdgeInsets.all(AppDimensions.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      useMaterial3: true,
    );
  }
}

/// Handles root-level navigation based on authentication state
class RootNavigationHandler extends StatefulWidget {
  const RootNavigationHandler({super.key});

  @override
  State<RootNavigationHandler> createState() => _RootNavigationHandlerState();
}

class _RootNavigationHandlerState extends State<RootNavigationHandler> {
  bool _appInitialized = false;

  @override
  void initState() {
    super.initState();
    _performInitialization();
  }

  Future<void> _performInitialization() async {
    final sessionCtrl = context.read<SessionController>();
    final fleetCtrl = context.read<VehicleFleetController>();
    
    await sessionCtrl.verifyExistingSession();
    fleetCtrl.setupMockFleet();
    
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (mounted) {
      setState(() {
        _appInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_appInitialized) {
      return const SplashScreen();
    }

    return Consumer<SessionController>(
      builder: (context, sessionCtrl, _) {
        if (!sessionCtrl.hasActiveSession) {
          return const LoginScreen();
        }

        final userAccountType = sessionCtrl.loggedInProfile?.accountType;
        
        return switch (userAccountType) {
          AccountType.regularUser => const UserHomeScreen(),
          AccountType.flightPilot => const PilotDashboardScreen(),
          AccountType.systemAdmin => const AdminDashboardScreen(),
          _ => const LoginScreen(),
        };
      },
    );
  }
}
