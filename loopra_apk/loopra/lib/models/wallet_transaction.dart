class WalletTransaction {
  final String id;
  final String userId;
  final double amount;
  final String type; // 'credit', 'debit'
  final String category; // 'waste_sale', 'withdrawal', 'bonus'
  final String description;
  final String? wasteItemId;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    this.wasteItemId,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] ?? 'credit',
      category: json['category'] ?? 'waste_sale',
      description: json['description'] ?? '',
      wasteItemId: json['wasteItemId'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'wasteItemId': wasteItemId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
