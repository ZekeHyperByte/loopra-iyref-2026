import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';
import '../../models/collection_point.dart';
import '../../services/firestore_service.dart';

class CollectionMapScreen extends StatefulWidget {
  const CollectionMapScreen({super.key});

  @override
  State<CollectionMapScreen> createState() => _CollectionMapScreenState();
}

class _CollectionMapScreenState extends State<CollectionMapScreen> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  bool _isLoading = true;

  static const LatLng _initialPosition = LatLng(-6.2088, 106.8456);
  static const double _initialZoom = 11.0;

  @override
  void initState() {
    super.initState();
    _loadCollectionPoints();
  }

  Future<void> _loadCollectionPoints() async {
    final service = FirestoreService();
    final points = await service.getCollectionPoints();
    setState(() {
      _markers.clear();
      for (final point in points) {
        _markers.add(
          Marker(
            point: LatLng(point.latitude, point.longitude),
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () => _onMarkerTapped(point),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lime.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  FontAwesomeIcons.locationDot,
                  color: AppColors.limeDark,
                  size: 22,
                ),
              ),
            ),
          ),
        );
      }
      _isLoading = false;
    });
  }

  void _onMarkerTapped(CollectionPoint point) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPointDetails(point),
    );
  }

  Widget _buildPointDetails(CollectionPoint point) {
    final capacityPercent = (point.currentCapacity / point.maxCapacity * 100).clamp(0, 100);
    final capacityColor = capacityPercent > 80
        ? AppColors.danger
        : capacityPercent > 50
            ? AppColors.warning
            : AppColors.lime;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.greenDeep,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lime.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(FontAwesomeIcons.locationDot, color: AppColors.lime),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      point.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      point.type,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _detailRow(FontAwesomeIcons.locationArrow, 'Address', point.address),
          if (point.phone != null)
            _detailRow(FontAwesomeIcons.phone, 'Phone', point.phone!),
          if (point.operatingHours != null)
            _detailRow(FontAwesomeIcons.clock, 'Hours', point.operatingHours!),
          const SizedBox(height: 20),
          const Text(
            'Current Capacity',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: capacityPercent / 100,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(capacityColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${point.currentCapacity.toStringAsFixed(0)} / ${point.maxCapacity.toStringAsFixed(0)} kg (${capacityPercent.toStringAsFixed(0)}%)',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.route),
              label: const Text('Get Directions'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                Text(value, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.lime))
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: _initialPosition,
                    initialZoom: _initialZoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.loopra.app',
                    ),
                    MarkerLayer(markers: _markers),
                  ],
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _floatingButton(
                          FontAwesomeIcons.arrowLeft,
                          () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lime,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Map Lokasi',
                            style: TextStyle(
                              color: AppColors.limeDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _floatingButton(
                          FontAwesomeIcons.circleInfo,
                          () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppColors.greenDeep,
        onPressed: () => _mapController.move(_initialPosition, _initialZoom),
        child: const Icon(FontAwesomeIcons.crosshairs, color: AppColors.white),
      ),
    );
  }

  Widget _floatingButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.greenDeep,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
