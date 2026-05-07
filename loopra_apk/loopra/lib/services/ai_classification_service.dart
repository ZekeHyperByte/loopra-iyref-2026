class AIClassificationService {
  static int _scriptedIndex = 0;

  // Bioethanol profiles: fruit-based, higher quality
  static final List<Map<String, dynamic>> _bioethanolResults = [
    {
      'wasteType': 'fruit',
      'specificType': 'Jeruk',
      'condition': 'Overripe',
      'grade': 'A',
      'recommendedProcess': 'Bioethanol',
      'estimatedValue': 75000.0,
      'weightKg': 30.0,
      'energyPotentialKwh': 24.0,
      'confidence': 0.95,
      'description': 'Jeruk - Overripe',
      'estimatedValuePerKg': 2500.0,
    },
    {
      'wasteType': 'fruit',
      'specificType': 'Mangga',
      'condition': 'Light Rot',
      'grade': 'B',
      'recommendedProcess': 'Bioethanol',
      'estimatedValue': 54000.0,
      'weightKg': 30.0,
      'energyPotentialKwh': 15.0,
      'confidence': 0.89,
      'description': 'Mangga - Light Rot',
      'estimatedValuePerKg': 1800.0,
    },
    {
      'wasteType': 'fruit',
      'specificType': 'Pisang',
      'condition': 'Overripe',
      'grade': 'A',
      'recommendedProcess': 'Bioethanol',
      'estimatedValue': 66000.0,
      'weightKg': 30.0,
      'energyPotentialKwh': 20.0,
      'confidence': 0.92,
      'description': 'Pisang - Overripe',
      'estimatedValuePerKg': 2200.0,
    },
  ];

  // Biogas profiles: any organic waste, lower quality acceptable
  static final List<Map<String, dynamic>> _biogasResults = [
    {
      'wasteType': 'vegetable',
      'specificType': 'Kangkung',
      'condition': 'Heavy Rot',
      'grade': 'C',
      'recommendedProcess': 'Biogas',
      'estimatedValue': 18000.0,
      'weightKg': 30.0,
      'energyPotentialKwh': 9.0,
      'confidence': 0.82,
      'description': 'Kangkung - Heavy Rot',
      'estimatedValuePerKg': 600.0,
    },
    {
      'wasteType': 'vegetable',
      'specificType': 'Kubis',
      'condition': 'Heavy Rot',
      'grade': 'C',
      'recommendedProcess': 'Biogas',
      'estimatedValue': 21000.0,
      'weightKg': 30.0,
      'energyPotentialKwh': 10.0,
      'confidence': 0.85,
      'description': 'Kubis - Heavy Rot',
      'estimatedValuePerKg': 700.0,
    },
    {
      'wasteType': 'mixed',
      'specificType': 'Campuran Sayur',
      'condition': 'Heavy Rot',
      'grade': 'C',
      'recommendedProcess': 'Biogas',
      'estimatedValue': 15000.0,
      'weightKg': 30.0,
      'energyPotentialKwh': 8.0,
      'confidence': 0.78,
      'description': 'Campuran Sayur - Heavy Rot',
      'estimatedValuePerKg': 500.0,
    },
  ];

  static Future<Map<String, dynamic>> classifyWaste(String imagePath, {String? description}) async {
    await Future.delayed(const Duration(seconds: 2));

    final result = Map<String, dynamic>.from(_bioethanolResults[_scriptedIndex]);
    _scriptedIndex = (_scriptedIndex + 1) % _bioethanolResults.length;

    return result;
  }

  static Future<Map<String, dynamic>> classifyWasteByProcess(String processType) async {
    await Future.delayed(const Duration(seconds: 2));

    if (processType.toLowerCase() == 'bioethanol') {
      final result = Map<String, dynamic>.from(_bioethanolResults[_scriptedIndex]);
      _scriptedIndex = (_scriptedIndex + 1) % _bioethanolResults.length;
      return result;
    } else {
      // Biogas uses a separate index to avoid syncing issues
      final biogasIndex = _scriptedIndex % _biogasResults.length;
      final result = Map<String, dynamic>.from(_biogasResults[biogasIndex]);
      _scriptedIndex = (_scriptedIndex + 1);
      return result;
    }
  }

  static Future<Map<String, dynamic>> classifyWasteAtIndex(int index) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final result = Map<String, dynamic>.from(_bioethanolResults[index % _bioethanolResults.length]);
    return result;
  }

  static void resetScript() {
    _scriptedIndex = 0;
  }

  static String getWasteCategory(String condition) {
    switch (condition) {
      case 'Overripe':
        return 'Bioethanol';
      case 'Light Rot':
        return 'Bioethanol/Biogas';
      case 'Heavy Rot':
        return 'Biogas';
      default:
        return 'Biogas';
    }
  }

  static String getConditionDescription(String condition) {
    switch (condition) {
      case 'Overripe':
        return 'Suitable for bioethanol production. High sugar content.';
      case 'Light Rot':
        return 'Partially degraded. Can be used for bioethanol or biogas.';
      case 'Heavy Rot':
        return 'Best suited for biogas production through anaerobic digestion.';
      default:
        return 'Suitable for biogas production.';
    }
  }

  static String getGradeForCondition(String condition) {
    switch (condition) {
      case 'Overripe':
        return 'A';
      case 'Light Rot':
        return 'B';
      case 'Heavy Rot':
        return 'C';
      default:
        return 'B';
    }
  }

  static double getPricePerKgForCondition(String condition) {
    switch (condition) {
      case 'Overripe':
        return 2500.0;
      case 'Light Rot':
        return 1800.0;
      case 'Heavy Rot':
        return 600.0;
      default:
        return 1200.0;
    }
  }
}
