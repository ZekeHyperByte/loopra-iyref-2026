class PickupSchedule {
  final String id;
  final String userId;
  final DateTime scheduledDate;
  final String? collectionPointId;
  final String? collectionPointName;
  final String status; // 'scheduled', 'in_transit', 'completed', 'cancelled'
  final double estimatedWeightKg;
  final String? truckType;
  final String? driverName;
  final String? driverPhone;

  PickupSchedule({
    required this.id,
    required this.userId,
    required this.scheduledDate,
    this.collectionPointId,
    this.collectionPointName,
    this.status = 'scheduled',
    required this.estimatedWeightKg,
    this.truckType,
    this.driverName,
    this.driverPhone,
  });

  factory PickupSchedule.fromJson(Map<String, dynamic> json) {
    return PickupSchedule(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      scheduledDate: DateTime.parse(json['scheduledDate'] ?? DateTime.now().toIso8601String()),
      collectionPointId: json['collectionPointId'],
      collectionPointName: json['collectionPointName'],
      status: json['status'] ?? 'scheduled',
      estimatedWeightKg: (json['estimatedWeightKg'] ?? 0.0).toDouble(),
      truckType: json['truckType'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'scheduledDate': scheduledDate.toIso8601String(),
      'collectionPointId': collectionPointId,
      'collectionPointName': collectionPointName,
      'status': status,
      'estimatedWeightKg': estimatedWeightKg,
      'truckType': truckType,
      'driverName': driverName,
      'driverPhone': driverPhone,
    };
  }
}
