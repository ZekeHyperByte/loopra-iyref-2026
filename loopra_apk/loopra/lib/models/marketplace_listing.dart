class MarketplaceListing {
  final String id;
  final String industryId;
  final String industryName;
  final String wasteType; // 'fruit', 'vegetable', 'mixed'
  final String processType; // 'Bioethanol', 'Biogas'
  final double quantityNeeded;
  final double pricePerKg;
  final String? description;
  final String status; // 'open', 'closed', 'filled'
  final DateTime deadline;
  final DateTime createdAt;

  MarketplaceListing({
    required this.id,
    required this.industryId,
    required this.industryName,
    required this.wasteType,
    required this.processType,
    required this.quantityNeeded,
    required this.pricePerKg,
    this.description,
    this.status = 'open',
    required this.deadline,
    required this.createdAt,
  });

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) {
    return MarketplaceListing(
      id: json['id'] ?? '',
      industryId: json['industryId'] ?? '',
      industryName: json['industryName'] ?? '',
      wasteType: json['wasteType'] ?? 'mixed',
      processType: json['processType'] ?? 'Biogas',
      quantityNeeded: (json['quantityNeeded'] ?? 0.0).toDouble(),
      pricePerKg: (json['pricePerKg'] ?? 0.0).toDouble(),
      description: json['description'],
      status: json['status'] ?? 'open',
      deadline: DateTime.parse(json['deadline'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'industryId': industryId,
      'industryName': industryName,
      'wasteType': wasteType,
      'processType': processType,
      'quantityNeeded': quantityNeeded,
      'pricePerKg': pricePerKg,
      'description': description,
      'status': status,
      'deadline': deadline.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
