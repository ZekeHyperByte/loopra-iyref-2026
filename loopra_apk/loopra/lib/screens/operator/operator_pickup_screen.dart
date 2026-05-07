import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/demo_state.dart';

class OperatorPickupScreen extends StatelessWidget {
  const OperatorPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      floatingActionButton: Consumer<DemoState>(
        builder: (context, state, _) {
          if (state.capacityPercent > 0.6) {
            return FloatingActionButton.extended(
              onPressed: () {
                state.requestPickup('Bank Sampah Inyong', 'Jl. Green Loop No. 42, Yogyakarta');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Permintaan pickup dikirim!'),
                    backgroundColor: AppColors.limeDark,
                  ),
                );
              },
              backgroundColor: AppColors.lime,
              foregroundColor: AppColors.limeDark,
              icon: const Icon(FontAwesomeIcons.truck),
              label: const Text('Request Pickup'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: SafeArea(
        child: Consumer<DemoState>(
          builder: (context, state, _) {
            return RefreshIndicator(
              color: AppColors.lime,
              backgroundColor: AppColors.cardDark,
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Pickup & Logistik',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelola kapasitas dan pickup limbah',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildCapacityCard(state),
                    const SizedBox(height: 24),
                    _buildPickupSection(context, state),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCapacityCard(DemoState state) {
    final percent = state.capacityPercent;
    final isWarning = percent > 0.8;
    final progressColor = isWarning ? AppColors.warning : AppColors.lime;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.warehouse,
                color: AppColors.lime,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Kapasitas Titik Kumpul',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isWarning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.triangleExclamation,
                        color: AppColors.warning,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Hampir Penuh',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${state.collectionPointCapacity.toInt()}',
                style: TextStyle(
                  color: progressColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '/ ${state.collectionPointMaxCapacity.toInt()} Kg',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${(percent * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: progressColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupSection(BuildContext context, DemoState state) {
    final pickups = state.activePickups;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.lime.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                FontAwesomeIcons.truck,
                color: AppColors.lime,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Pickup Aktif',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            if (pickups.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.lime.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${pickups.length}',
                  style: const TextStyle(
                    color: AppColors.lime,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (pickups.isEmpty)
          _buildEmptyState(
            FontAwesomeIcons.truckRampBox,
            'Belum ada pickup aktif',
            'Request pickup saat kapasitas sudah di atas 60%',
          )
        else
          ...pickups.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildPickupCard(p, state),
          )),
      ],
    );
  }

  Widget _buildPickupCard(PickupRequest pickup, DemoState state) {
    final statusLabel = _pickupStatusLabel(pickup.status);
    final statusColor = _pickupStatusColor(pickup.status);

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
            children: [
              const Icon(FontAwesomeIcons.truck, color: AppColors.lime, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pickup.collectionPointName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (pickup.driverName != null) ...[
            Row(
              children: [
                const Icon(FontAwesomeIcons.user, color: AppColors.muted, size: 12),
                const SizedBox(width: 6),
                Text(
                  pickup.driverName!,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                if (pickup.driverPhone != null) ...[
                  const SizedBox(width: 12),
                  const Icon(FontAwesomeIcons.phone, color: AppColors.muted, size: 10),
                  const SizedBox(width: 4),
                  Text(
                    pickup.driverPhone!,
                    style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              const Icon(FontAwesomeIcons.weightHanging, color: AppColors.muted, size: 12),
              const SizedBox(width: 6),
              Text(
                '${pickup.estimatedWeightKg.toStringAsFixed(0)} Kg',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (pickup.status == 'requested' || pickup.status == 'in_transit')
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      state.confirmTruckArrived(pickup.id);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.lime,
                      side: const BorderSide(color: AppColors.lime),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Konfirmasi Tiba', style: TextStyle(fontSize: 12)),
                  ),
                ),
              if (pickup.status == 'loading')
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      state.confirmTruckDeparted(pickup.id);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Konfirmasi Berangkat', style: TextStyle(fontSize: 12)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _pickupStatusLabel(String status) {
    switch (status) {
      case 'requested':
        return 'Diminta';
      case 'in_transit':
        return 'Dalam Perjalanan';
      case 'loading':
        return 'Loading';
      case 'departed':
        return 'Berangkat';
      case 'delivered':
        return 'Terkirim';
      default:
        return status;
    }
  }

  Color _pickupStatusColor(String status) {
    switch (status) {
      case 'requested':
        return AppColors.warning;
      case 'in_transit':
        return AppColors.warning;
      case 'loading':
        return AppColors.lime;
      case 'departed':
        return AppColors.lime;
      case 'delivered':
        return AppColors.lime;
      default:
        return AppColors.muted;
    }
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.muted, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}