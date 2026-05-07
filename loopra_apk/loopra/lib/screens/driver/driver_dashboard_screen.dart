import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/demo_state.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Consumer<DemoState>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildActivePickupsSection(state, context),
                  const SizedBox(height: 24),
                  _buildRouteInfoCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.greenCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            FontAwesomeIcons.truck,
            color: AppColors.lime,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, Pak Slamet!',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Driver Dashboard',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.greenCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            FontAwesomeIcons.bell,
            color: AppColors.white,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActivePickupsSection(DemoState state, BuildContext context) {
    final pickups = state.activePickups;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pickup Aktif',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (pickups.isEmpty)
          _buildEmptyState(
            FontAwesomeIcons.truckRampBox,
            'Belum ada pickup yang ditugaskan',
          )
        else
          ...pickups.map((pickup) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildPickupCard(pickup, context),
              )),
      ],
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.muted, size: 40),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPickupCard(PickupRequest pickup, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  pickup.collectionPointName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildStatusBadge(pickup.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.locationDot,
                color: AppColors.muted,
                size: 12,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  pickup.collectionPointAddress,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                FontAwesomeIcons.weightHanging,
                '${pickup.estimatedWeightKg.toStringAsFixed(0)} Kg',
              ),
              const SizedBox(width: 12),
              if (pickup.scheduledDate != null)
                _buildInfoChip(
                  FontAwesomeIcons.clock,
                  _formatTime(pickup.scheduledDate!),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActionButton(pickup, context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final config = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.$2.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        config.$1,
        style: TextStyle(
          color: config.$2,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (String, Color) _statusConfig(String status) {
    switch (status) {
      case 'requested':
        return ('Requested', AppColors.warning);
      case 'in_transit':
        return ('In Transit', const Color(0xFF3B82F6));
      case 'loading':
        return ('Loading', const Color(0xFFF97316));
      case 'departed':
        return ('Departed', AppColors.lime);
      case 'delivered':
        return ('Delivered', AppColors.lime);
      default:
        return (status, AppColors.muted);
    }
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greenDeep,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.lime, size: 11),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.lime,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(PickupRequest pickup, BuildContext context) {
    final state = context.read<DemoState>();

    switch (pickup.status) {
      case 'requested':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => state.assignDriver(pickup.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lime,
              foregroundColor: AppColors.limeDark,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Mulai Perjalanan',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        );
      case 'in_transit':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => state.confirmTruckArrived(pickup.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lime,
              foregroundColor: AppColors.limeDark,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Tiba di Lokasi',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        );
      case 'loading':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => state.confirmTruckDeparted(pickup.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lime,
              foregroundColor: AppColors.limeDark,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Muatan Selesai, Berangkat',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        );
      case 'departed':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.lime.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lime.withValues(alpha: 0.3)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.truckFast, color: AppColors.lime, size: 16),
              SizedBox(width: 8),
              Text(
                'Dalam Perjalanan ke Pembeli',
                style: TextStyle(
                  color: AppColors.lime,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRouteInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Info Rute',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.greenCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildRoutePoint(
                FontAwesomeIcons.locationDot,
                'Collection Point',
                'Jl. Raya Industri No. 45, Bekasi',
                AppColors.lime,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      width: 2,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.lime.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '~12 km est.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildRoutePoint(
                FontAwesomeIcons.building,
                'Pertamina Facility',
                'Jl. Medan Merdeka Timur No. 1, Jakarta',
                AppColors.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoutePoint(IconData icon, String title, String address, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 12),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}