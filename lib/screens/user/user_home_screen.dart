import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_controller.dart';
import '../../providers/vehicle_fleet_controller.dart';
import '../../providers/booking_controller.dart';
import '../../constants/app_theme.dart';

/// Primary interface for regular users to browse and book flights
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  Future<void> _initializeData() async {
    final fleetController = context.read<VehicleFleetController>();
    final bookingController = context.read<BookingController>();
    final sessionController = context.read<SessionController>();
    
    await fleetController.retrieveAvailableFleet();
    
    final currentUser = sessionController.loggedInProfile;
    if (currentUser != null) {
      await bookingController.retrieveCustomerBookings(currentUser.accountId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _activeTabIndex,
        children: const [
          _ExploreTab(),
          _MyTripsTab(),
          _ConversationsTab(),
          _AccountTab(),
        ],
      ),
      bottomNavigationBar: _CustomBottomBar(
        activeIndex: _activeTabIndex,
        onTabSelected: (index) => setState(() => _activeTabIndex = index),
      ),
    );
  }
}

class _ExploreTab extends StatelessWidget {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _CustomAppBar(),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _WelcomeBanner(),
              const SizedBox(height: 24),
              _QuickActionsGrid(),
              const SizedBox(height: 28),
              _FleetDisplay(),
            ]),
          ),
        ),
      ],
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('Fly Express'),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          onPressed: () {},
        ),
        Consumer<SessionController>(
          builder: (context, sessionCtrl, _) {
            final userName = sessionCtrl.loggedInProfile?.fullName ?? '';
            final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
            return Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Text(initial, style: const TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SessionController>(
      builder: (context, sessionCtrl, _) {
        final userName = sessionCtrl.loggedInProfile?.fullName ?? 'Traveler';
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.accent.withOpacity(0.2), AppColors.primary.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName!',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Where would you like to fly today?',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _ActionTile(
          title: 'Book Now',
          icon: Icons.add_location_alt_rounded,
          color: AppColors.primary,
          onTap: () {},
        ),
        _ActionTile(
          title: 'Schedule Trip',
          icon: Icons.calendar_today_rounded,
          color: AppColors.accent,
          onTap: () {},
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FleetDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available Drones Nearby', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Consumer<VehicleFleetController>(
          builder: (context, fleetCtrl, _) {
            if (fleetCtrl.fetchingData) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (fleetCtrl.vehicleInventory.isEmpty) {
              return _EmptyState();
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fleetCtrl.vehicleInventory.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final vehicle = fleetCtrl.vehicleInventory[index];
                return _DroneCard(vehicle: vehicle);
              },
            );
          },
        ),
      ],
    );
  }
}

class _DroneCard extends StatelessWidget {
  final vehicle;

  const _DroneCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flight_rounded, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.modelDesignation,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle.seatingConfig.openSeats} of ${vehicle.seatingConfig.maximumCapacity} seats available',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.battery_charging_full, size: 16, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      '${vehicle.powerStatus.chargePercentage.toInt()}%',
                      style: const TextStyle(fontSize: 13, color: AppColors.success),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.flight_takeoff_rounded, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No drones available',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back soon for available flights',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MyTripsTab extends StatelessWidget {
  const _MyTripsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: Consumer<BookingController>(
        builder: (context, bookingCtrl, _) {
          if (bookingCtrl.customerBookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.luggage_rounded, size: 80, color: AppColors.textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 20),
                  const Text('No trips yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Book your first flight!', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookingCtrl.customerBookings.length,
            itemBuilder: (context, index) {
              final trip = bookingCtrl.customerBookings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${trip.route.originLocation} → ${trip.route.destinationLocation}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            trip.currentState.name,
                            style: const TextStyle(fontSize: 12, color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'UGX ${trip.pricing.fareAmount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ConversationsTab extends StatelessWidget {
  const _ConversationsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const Center(child: Text('Chat feature - Coming soon')),
    );
  }
}

class _AccountTab extends StatelessWidget {
  const _AccountTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Consumer<SessionController>(
        builder: (context, sessionCtrl, _) {
          final user = sessionCtrl.loggedInProfile;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        user?.fullName.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(fontSize: 36, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(user?.fullName ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(user?.emailAddress ?? '', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                title: const Text('Sign Out'),
                onTap: () => sessionCtrl.terminateSession(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CustomBottomBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  const _CustomBottomBar({required this.activeIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomBarItem(
                icon: Icons.explore_rounded,
                label: 'Explore',
                isActive: activeIndex == 0,
                onTap: () => onTabSelected(0),
              ),
              _BottomBarItem(
                icon: Icons.airplane_ticket_rounded,
                label: 'Trips',
                isActive: activeIndex == 1,
                onTap: () => onTabSelected(1),
              ),
              _BottomBarItem(
                icon: Icons.chat_bubble_rounded,
                label: 'Chat',
                isActive: activeIndex == 2,
                onTap: () => onTabSelected(2),
              ),
              _BottomBarItem(
                icon: Icons.account_circle_rounded,
                label: 'Account',
                isActive: activeIndex == 3,
                onTap: () => onTabSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
