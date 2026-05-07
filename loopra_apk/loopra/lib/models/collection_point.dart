class CollectionPoint {
  final String id;
  final String name;
  final String type; // 'Market Hub', 'Farm Collection', 'Mobile Unit'
  final double latitude;
  final double longitude;
  final String address;
  final String? phone;
  final String? operatingHours;
  final bool isActive;
  final double currentCapacity;
  final double maxCapacity;

  CollectionPoint({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.phone,
    this.operatingHours,
    this.isActive = true,
    this.currentCapacity = 0.0,
    this.maxCapacity = 1000.0,
  });

  factory CollectionPoint.fromJson(Map<String, dynamic> json) {
    return CollectionPoint(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'Market Hub',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      phone: json['phone'],
      operatingHours: json['operatingHours'],
      isActive: json['isActive'] ?? true,
      currentCapacity: (json['currentCapacity'] ?? 0.0).toDouble(),
      maxCapacity: (json['maxCapacity'] ?? 1000.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phone': phone,
      'operatingHours': operatingHours,
      'isActive': isActive,
      'currentCapacity': currentCapacity,
      'maxCapacity': maxCapacity,
    };
  }
}
