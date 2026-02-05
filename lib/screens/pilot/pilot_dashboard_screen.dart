import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_controller.dart';
import '../../constants/app_theme.dart';

/// Control center for drone pilots
class PilotDashboardScreen extends StatelessWidget {
  const PilotDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Pilot Dashboard'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () => context.read<SessionController>().terminateSession(),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _StatisticsCards(),
                const SizedBox(height: 24),
                _UpcomingFlights(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatCard(
          title: 'Total Earnings',
          value: 'UGX 2.5M',
          icon: Icons.monetization_on_rounded,
          color: AppColors.success,
        ),
        _StatCard(
          title: 'Flights Today',
          value: '5',
          icon: Icons.flight_rounded,
          color: AppColors.primary,
        ),
        _StatCard(
          title: 'Rating',
          value: '4.8',
          icon: Icons.star_rounded,
          color: AppColors.accent,
        ),
        _StatCard(
          title: 'Hours Flown',
          value: '342',
          icon: Icons.access_time_rounded,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _UpcomingFlights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upcoming Flights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: const Center(
            child: Text('No upcoming flights', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ),
      ],
    );
  }
}
