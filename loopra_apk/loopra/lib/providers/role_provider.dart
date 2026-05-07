import 'package:flutter/material.dart';

enum AppRole { seller, operator, driver }

class RoleProvider extends ChangeNotifier {
  AppRole? _currentRole;

  AppRole? get currentRole => _currentRole;
  bool get hasRole => _currentRole != null;

  String get roleLabel {
    switch (_currentRole) {
      case AppRole.seller:
        return 'Penjual';
      case AppRole.operator:
        return 'Operator';
      case AppRole.driver:
        return 'Pengemudi';
      default:
        return '';
    }
  }

  String get roleDescription {
    switch (_currentRole) {
      case AppRole.seller:
        return 'Jual limbah organik & dapatkan pembayaran';
      case AppRole.operator:
        return 'Kelola titik pengumpulan & verifikasi limbah';
      case AppRole.driver:
        return 'Terima pickup & optimalkan rute pengiriman';
      default:
        return '';
    }
  }

  IconData get roleIcon {
    switch (_currentRole) {
      case AppRole.seller:
        return Icons.person;
      case AppRole.operator:
        return Icons.admin_panel_settings;
      case AppRole.driver:
        return Icons.local_shipping;
      default:
        return Icons.people;
    }
  }

  void setRoleFromUserType(String userType) {
    switch (userType) {
      case 'operator':
        _currentRole = AppRole.operator;
        break;
      case 'driver':
        _currentRole = AppRole.driver;
        break;
      case 'seller':
      case 'farmer':
      case 'vendor':
      default:
        _currentRole = AppRole.seller;
        break;
    }
    notifyListeners();
  }

  void setRole(AppRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void clearRole() {
    _currentRole = null;
    notifyListeners();
  }
}