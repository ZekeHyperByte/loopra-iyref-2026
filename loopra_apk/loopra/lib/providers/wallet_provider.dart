import 'package:flutter/material.dart';
import '../models/wallet_transaction.dart';
import '../services/firestore_service.dart';

class WalletProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<WalletTransaction> _transactions = [];
  double _balance = 1250000.0; // Demo balance
  bool _isLoading = false;
  String? _error;

  List<WalletTransaction> get transactions => _transactions;
  double get balance => _balance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTransactions(String userId) async {
    _setLoading(true);
    try {
      _transactions = await _firestoreService.getWalletTransactions(userId);
      _calculateBalance();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTransaction(String userId, double amount, String type, String category, String description, {String? wasteItemId}) async {
    _setLoading(true);
    try {
      final transaction = WalletTransaction(
        id: 'wt_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        amount: amount,
        type: type,
        category: category,
        description: description,
        wasteItemId: wasteItemId,
        createdAt: DateTime.now(),
      );

      await _firestoreService.addWalletTransaction(transaction);
      _transactions.insert(0, transaction);
      _calculateBalance();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _calculateBalance() {
    _balance = 1250000.0; // Base demo balance
    for (final transaction in _transactions) {
      if (transaction.type == 'credit') {
        _balance += transaction.amount;
      } else {
        _balance -= transaction.amount;
      }
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
