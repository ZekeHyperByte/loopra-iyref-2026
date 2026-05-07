import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/widgets/pill_nav_bar.dart';
import '../driver/driver_dashboard_screen.dart';
import '../map/collection_map_screen.dart';
import '../profile/profile_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DriverDashboardScreen(),
    CollectionMapScreen(),
    ProfileScreen(),
  ];

  final List<PillNavItem> _navItems = const [
    PillNavItem(icon: FontAwesomeIcons.truck, label: 'Pickup'),
    PillNavItem(icon: FontAwesomeIcons.map, label: 'Rute'),
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