import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/role_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ─── Mock User Data ───
  final String _name = 'Ahmad Suryadi';
  final String _email = 'ahmad.suryadi@email.com';
  final String _phone = '+62 812-3456-7890';
  final String _userType = 'farmer'; // farmer, vendor, collector, industry
  final String _joinedDate = 'Maret 2025';
  final String _avatarSvg = 'assets/images/doodle-01.svg';

  // ─── Mock Stats ───
  final int _totalDeposits = 142;
  final double _totalWeight = 3280.5; // kg
  final int _missionStreak = 12; // days

  String get _userTypeLabel {
    switch (_userType) {
      case 'farmer':
        return 'Petani';
      case 'vendor':
        return 'Pedagang';
      case 'collector':
        return 'Kolektor';
      case 'industry':
        return 'Industri';
      default:
        return 'Pengguna';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildSettingsSection(),
            const SizedBox(height: 24),
            _buildLogoutButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E2F), Color(0xFF2D8A4E)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Avatar + edit icon
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: SvgPicture.asset(
                    _avatarSvg,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showToast('Edit foto profil'),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.pen,
                    color: AppColors.limeDark,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _name,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              _userTypeLabel,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(FontAwesomeIcons.envelope, _email),
          const SizedBox(height: 8),
          _buildInfoRow(FontAwesomeIcons.phone, _phone),
          const SizedBox(height: 8),
          _buildInfoRow(FontAwesomeIcons.calendarDays, 'Bergabung $_joinedDate'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.white.withValues(alpha: 0.7), size: 12),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.85),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: FontAwesomeIcons.recycle,
              value: '$_totalDeposits',
              label: 'Total Deposit',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: FontAwesomeIcons.weightHanging,
              value: _totalWeight.toStringAsFixed(1),
              label: 'Kg Terkumpul',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: FontAwesomeIcons.fire,
              value: '$_missionStreak',
              label: 'Streak Hari',
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.lime, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.lime,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Pengaturan',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _settingsTile(
            icon: FontAwesomeIcons.userPen,
            iconColor: AppColors.lime,
            title: 'Edit Profil',
            subtitle: 'Ubah nama, foto, dan informasi akun',
            onTap: () => _showToast('Edit Profil'),
          ),
          const SizedBox(height: 8),
          _settingsTile(
            icon: FontAwesomeIcons.bell,
            iconColor: AppColors.warning,
            title: 'Notifikasi',
            subtitle: 'Atur preferensi notifikasi Anda',
            trailing: _buildToggleSwitch(true),
          ),
          const SizedBox(height: 8),
          _settingsTile(
            icon: FontAwesomeIcons.globe,
            iconColor: AppColors.lime,
            title: 'Bahasa',
            subtitle: 'Indonesia',
            onTap: () => _showToast('Ganti Bahasa'),
          ),
          const SizedBox(height: 8),
          _settingsTile(
            icon: FontAwesomeIcons.shieldHalved,
            iconColor: AppColors.lime,
            title: 'Keamanan & Privasi',
            subtitle: 'Ubah kata sandi dan privasi',
            onTap: () => _showToast('Keamanan & Privasi'),
          ),
          const SizedBox(height: 8),
          _settingsTile(
            icon: FontAwesomeIcons.circleQuestion,
            iconColor: AppColors.muted,
            title: 'Pusat Bantuan',
            subtitle: 'FAQ, panduan, dan dukungan',
            onTap: () => _showToast('Pusat Bantuan'),
          ),
          const SizedBox(height: 8),
          _settingsTile(
            icon: FontAwesomeIcons.circleInfo,
            iconColor: AppColors.muted,
            title: 'Tentang Loopra',
            subtitle: 'Versi 1.0.0 · Kampus Tinggi',
            onTap: () => _showToast('Tentang Loopra'),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.greenCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  FontAwesomeIcons.chevronRight,
                  color: AppColors.muted,
                  size: 14,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(bool value) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        color: value ? AppColors.lime : const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(999),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _showLogoutDialog(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.danger.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.arrowRightFromBracket,
                  color: AppColors.danger, size: 16),
              SizedBox(width: 10),
              Text(
                'Keluar dari Akun',
                style: TextStyle(
                  color: AppColors.danger,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.greenDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar?',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Anda akan keluar dari akun Loopra. Yakin?',
          style: TextStyle(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
              context.read<RoleProvider>().clearRole();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
