import 'package:flutter/material.dart';
import '../models/waste_item.dart';
import '../services/ai_classification_service.dart';
import '../services/firestore_service.dart';

class WasteProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<WasteItem> _wasteItems = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _lastClassification;

  List<WasteItem> get wasteItems => _wasteItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get lastClassification => _lastClassification;

  Future<void> loadWasteItems(String userId) async {
    _setLoading(true);
    try {
      _wasteItems = await _firestoreService.getWasteItems(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> classifyWaste(String imagePath, {String? description}) async {
    _setLoading(true);
    try {
      final result = await AIClassificationService.classifyWaste(imagePath, description: description);
      _lastClassification = result;
      _error = null;
      return result;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<WasteItem> submitWasteItem(String userId, String imagePath, Map<String, dynamic> classification) async {
    _setLoading(true);
    try {
      final wasteItem = WasteItem(
        id: 'wi_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        imageUrl: imagePath,
        wasteType: classification['wasteType'] ?? 'fruit',
        condition: classification['condition'] ?? 'Overripe',
        recommendedProcess: classification['recommendedProcess'] ?? 'Biogas',
        estimatedValue: (classification['estimatedValue'] ?? 0.0).toDouble(),
        weightKg: (classification['weightKg'] ?? 0.0).toDouble(),
        energyPotentialKwh: (classification['energyPotentialKwh'] ?? 0.0).toDouble(),
        description: classification['description'] ?? '',
        status: 'pending',
        createdAt: DateTime.now(),
      );

      final addedItem = await _firestoreService.addWasteItem(wasteItem);
      _wasteItems.insert(0, addedItem);
      _error = null;
      return addedItem;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void clearLastClassification() {
    _lastClassification = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
