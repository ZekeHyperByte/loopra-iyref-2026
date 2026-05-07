import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> mockLogin(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final Map<String, Map<String, dynamic>> mockUsers = {
      'seller@loopra.id': {
        'name': 'Budi Santoso',
        'userType': 'seller',
        'phone': '081234567890',
      },
      'operator@loopra.id': {
        'name': 'Pak Joko',
        'userType': 'operator',
        'phone': '081298765432',
      },
      'driver@loopra.id': {
        'name': 'Pak Slamet',
        'userType': 'driver',
        'phone': '081376543210',
      },
    };

    final userData = mockUsers[email.toLowerCase()];
    if (userData != null && password == 'password') {
      _user = UserModel(
        id: 'demo_${userData['userType']}',
        name: userData['name']!,
        email: email.toLowerCase(),
        phone: userData['phone']!,
        userType: userData['userType']!,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
      _error = null;
    } else {
      _error = 'Email atau password salah';
      _user = null;
    }

    _setLoading(false);
  }

  Future<void> logout() async {
    _user = null;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}