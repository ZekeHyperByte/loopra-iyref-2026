import 'package:flutter/material.dart';
import '../models/marketplace_listing.dart';
import '../services/firestore_service.dart';

class MarketplaceProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<MarketplaceListing> _listings = [];
  bool _isLoading = false;
  String? _error;

  List<MarketplaceListing> get listings => _listings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadListings() async {
    _setLoading(true);
    try {
      _listings = await _firestoreService.getMarketplaceListings();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
