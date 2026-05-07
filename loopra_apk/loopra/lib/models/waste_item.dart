class WasteItem {
  final String id;
  final String userId;
  final String? imageUrl;
  final String wasteType; // 'fruit', 'vegetable'
  final String condition; // 'Overripe', 'Light Rot', 'Heavy Rot'
  final String recommendedProcess; // 'Bioethanol', 'Biogas'
  final double estimatedValue;
  final double weightKg;
  final double energyPotentialKwh;
  final String? description;
  final String status; // 'pending', 'collected', 'processed'
  final DateTime createdAt;
  final String? collectionPointId;

  WasteItem({
    required this.id,
    required this.userId,
    this.imageUrl,
    required this.wasteType,
    required this.condition,
    required this.recommendedProcess,
    required this.estimatedValue,
    required this.weightKg,
    required this.energyPotentialKwh,
    this.description,
    this.status = 'pending',
    required this.createdAt,
    this.collectionPointId,
  });

  factory WasteItem.fromJson(Map<String, dynamic> json) {
    return WasteItem(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      imageUrl: json['imageUrl'],
      wasteType: json['wasteType'] ?? 'fruit',
      condition: json['condition'] ?? 'Overripe',
      recommendedProcess: json['recommendedProcess'] ?? 'Biogas',
      estimatedValue: (json['estimatedValue'] ?? 0.0).toDouble(),
      weightKg: (json['weightKg'] ?? 0.0).toDouble(),
      energyPotentialKwh: (json['energyPotentialKwh'] ?? 0.0).toDouble(),
      description: json['description'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      collectionPointId: json['collectionPointId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'wasteType': wasteType,
      'condition': condition,
      'recommendedProcess': recommendedProcess,
      'estimatedValue': estimatedValue,
      'weightKg': weightKg,
      'energyPotentialKwh': energyPotentialKwh,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'collectionPointId': collectionPointId,
    };
  }
}
