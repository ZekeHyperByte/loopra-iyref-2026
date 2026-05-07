import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/widgets/pill_nav_bar.dart';
import '../operator/operator_dashboard_screen.dart';
import '../operator/operator_verifikasi_screen.dart';
import '../operator/operator_pickup_screen.dart';
import '../profile/profile_screen.dart';

class OperatorHomeScreen extends StatefulWidget {
  const OperatorHomeScreen({super.key});

  @override
  State<OperatorHomeScreen> createState() => _OperatorHomeScreenState();
}

class _OperatorHomeScreenState extends State<OperatorHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    OperatorDashboardScreen(),
    OperatorVerifikasiScreen(),
    OperatorPickupScreen(),
    ProfileScreen(),
  ];

  final List<PillNavItem> _navItems = const [
    PillNavItem(icon: FontAwesomeIcons.gaugeHigh, label: 'Dashboard'),
    PillNavItem(icon: FontAwesomeIcons.clipboardCheck, label: 'Verifikasi'),
    PillNavItem(icon: FontAwesomeIcons.truck, label: 'Pickup'),
    PillNavItem(icon: FontAwesomeIcons.user, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: PillNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}