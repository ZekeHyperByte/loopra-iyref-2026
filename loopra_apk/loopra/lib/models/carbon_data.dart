class CarbonData {
  final String id;
  final String userId;
  final DateTime date;
  final double methanePreventedKg;
  final double carbonCreditsEarned;
  final double totalWasteProcessedKg;
  final double energyGeneratedKwh;

  CarbonData({
    required this.id,
    required this.userId,
    required this.date,
    required this.methanePreventedKg,
    required this.carbonCreditsEarned,
    required this.totalWasteProcessedKg,
    required this.energyGeneratedKwh,
  });

  factory CarbonData.fromJson(Map<String, dynamic> json) {
    return CarbonData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      methanePreventedKg: (json['methanePreventedKg'] ?? 0.0).toDouble(),
      carbonCreditsEarned: (json['carbonCreditsEarned'] ?? 0.0).toDouble(),
      totalWasteProcessedKg: (json['totalWasteProcessedKg'] ?? 0.0).toDouble(),
      energyGeneratedKwh: (json['energyGeneratedKwh'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'methanePreventedKg': methanePreventedKg,
      'carbonCreditsEarned': carbonCreditsEarned,
      'totalWasteProcessedKg': totalWasteProcessedKg,
      'energyGeneratedKwh': energyGeneratedKwh,
    };
  }
}
