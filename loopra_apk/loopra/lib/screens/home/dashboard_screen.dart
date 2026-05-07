import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/demo_state.dart';
import '../location/location_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isBalanceVisible = true;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final demoState = context.watch<DemoState>();
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF165044), Color(0xFF3F775E), Color(0xFFBFE7AC)],
                  stops: [0.0, 0.40, 1.0],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: EdgeInsets.fromLTRB(20, 20 + MediaQuery.paddingOf(context).top, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildWalletCard(demoState),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildQuickActions(context)),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildStatsRow()),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildContributionBanner()),
            const SizedBox(height: 24),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildBioAssetPrices()),
            const SizedBox(height: 24),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildTransactionHistory()),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.greenDeep,
          child: const Icon(FontAwesomeIcons.user, color: AppColors.lime, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hai, Penjaga Energi!', style: TextStyle(color: AppColors.lime.withValues(alpha: 0.7), fontSize: 12)),
              const Text('Ahmad S', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        _iconButton(FontAwesomeIcons.bell),
        const SizedBox(width: 8),
        _iconButton(FontAwesomeIcons.question),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: AppColors.white, size: 16),
    );
  }

  Widget _buildWalletCard(DemoState demoState) {
    final balance = demoState.sellerBalance;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: AppColors.walletGradient, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: AppColors.greenPrimary.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(999)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(FontAwesomeIcons.recycle, color: AppColors.white, size: 16),
                        SizedBox(width: 8),
                        Text('loopra', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                    Row(children: [
                      _smallIconButton(FontAwesomeIcons.creditCard),
                      const SizedBox(width: 8),
                      _smallIconButton(FontAwesomeIcons.paperPlane),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                Row(children: [
                  const Text('Total Energy Credits', style: TextStyle(color: AppColors.white, fontSize: 12)),
                  const SizedBox(width: 4),
                  Icon(FontAwesomeIcons.circleInfo, color: AppColors.white.withValues(alpha: 0.6), size: 12),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(FontAwesomeIcons.coins, color: AppColors.warning, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    _isBalanceVisible ? '${_formatNumber(balance)} EC' : '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                    style: const TextStyle(color: AppColors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _toggleBalanceVisibility,
                    child: Icon(_isBalanceVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, color: AppColors.white.withValues(alpha: 0.6), size: 18),
                  ),
                ]),
                const SizedBox(height: 4),
                Text(
                  _isBalanceVisible ? '\u2248 Rp ${_formatNumber(balance)},-' : '\u2248 Rp \u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                  style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: const BoxDecoration(color: Color(0xFF0A0A0A), borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('Target Harian', style: TextStyle(color: AppColors.white, fontSize: 11)),
                  const SizedBox(width: 4),
                  const Icon(FontAwesomeIcons.arrowTrendUp, color: AppColors.lime, size: 10),
                  const Spacer(),
                  const Text('85%', style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.85,
                    backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.5),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lime),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Text('85% dari target harian tercapai', style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    return value.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  Widget _smallIconButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: AppColors.greenPrimary.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: AppColors.white, size: 14),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: AppColors.greenCard, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _quickAction(FontAwesomeIcons.building, 'Cari Hub', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LocationListScreen()),
            );
          }),
          _quickAction(FontAwesomeIcons.ticket, 'Voucher', () {}),
          _quickAction(FontAwesomeIcons.earthAsia, 'Edu-Bio', () {}),
          _quickAction(FontAwesomeIcons.bolt, 'Misi Harian', () {}),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppColors.white, fontSize: 11)),
      ]),
    );
  }

  Widget _buildStatsRow() {
    return Row(children: [
      Expanded(child: _statCard(FontAwesomeIcons.seedling, '450', 'Impact Points')),
      const SizedBox(width: 12),
      Expanded(child: _statCard(FontAwesomeIcons.seedling, '12,4', 'CO2 Prevented', suffix: 'Kg')),
    ]);
  }

  Widget _statCard(IconData icon, String value, String label, {String? suffix}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.greenCard, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.lime, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.white, fontSize: 12)),
              const SizedBox(height: 4),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(value, style: const TextStyle(color: AppColors.lime, fontSize: 32, fontWeight: FontWeight.bold)),
                if (suffix != null)
                  Padding(padding: const EdgeInsets.only(top: 4), child: Text(suffix, style: const TextStyle(color: AppColors.lime, fontSize: 16))),
              ]),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildContributionBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.greenCard, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: AppColors.greenDeep, borderRadius: BorderRadius.circular(8)),
          child: const Icon(FontAwesomeIcons.bolt, color: AppColors.lime, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: RichText(
          text: const TextSpan(
            style: TextStyle(color: AppColors.white, fontSize: 13),
            children: [
              TextSpan(text: 'Kontribusi Anda hari ini telah '),
              TextSpan(text: 'menerangi 5 rumah melalui Biogas', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        )),
      ]),
    );
  }

  Widget _buildBioAssetPrices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Harga Bio-Asset Hari Ini', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          TextButton(onPressed: () {}, child: const Text('Lihat semua', style: TextStyle(color: AppColors.lime, fontSize: 12))),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _bioAssetCard('Limbah Jeruk', '+4.2%', '2.500 EC/Kg'),
              const SizedBox(width: 12),
              _bioAssetCard('Pulp Wortel', '+2.4%', '2.100 EC/Kg'),
              const SizedBox(width: 12),
              _bioAssetCard('Kulit Mangga', '+3.1%', '2.800 EC/Kg'),
              const SizedBox(width: 12),
              _bioAssetCard('Daun Singkong', '+1.8%', '1.500 EC/Kg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bioAssetCard(String name, String change, String price) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.greenCard, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Icon(FontAwesomeIcons.leaf, color: AppColors.lime, size: 14),
            Row(children: [
              const Icon(FontAwesomeIcons.arrowUp, color: AppColors.lime, size: 10),
              const SizedBox(width: 2),
              Text(change, style: const TextStyle(color: AppColors.lime, fontSize: 11)),
            ]),
          ]),
          const Spacer(),
          Text(name, style: const TextStyle(color: AppColors.white, fontSize: 13)),
          const SizedBox(height: 2),
          Text(price, style: const TextStyle(color: AppColors.lime, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Riwayat Transaksi', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          TextButton(onPressed: () {}, child: const Text('Lihat semua', style: TextStyle(color: AppColors.lime, fontSize: 12))),
        ]),
        const SizedBox(height: 12),
        _transactionItem(FontAwesomeIcons.arrowDown, AppColors.lime, 'Deposit 50Kg Kulit Mangga', '2 jam yang lalu', '+50.000 EC', true),
        const SizedBox(height: 8),
        _transactionItem(FontAwesomeIcons.arrowUp, AppColors.muted, 'Konversi ke Bioetanol Hub', '2 jam yang lalu', '-12.500 EC', false),
        const SizedBox(height: 8),
        _transactionItem(FontAwesomeIcons.bolt, AppColors.lime, 'Bonus Misi Penjaga Energi', 'Kemarin, 18:42', '+8.200 EC', true),
      ],
    );
  }

  Widget _transactionItem(IconData icon, Color iconColor, String title, String time, String amount, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.greenCard, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: isPositive ? AppColors.lime.withValues(alpha: 0.1) : const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        )),
        Text(amount, style: TextStyle(color: isPositive ? AppColors.lime : AppColors.danger, fontSize: 14, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}