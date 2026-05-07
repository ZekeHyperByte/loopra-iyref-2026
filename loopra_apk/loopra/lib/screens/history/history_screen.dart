import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../models/wallet_transaction.dart';
import '../../models/waste_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Mock Transactions ───
  final List<WalletTransaction> _mockTransactions = [
    WalletTransaction(
      id: 'wt_001',
      userId: 'u1',
      amount: 50000,
      type: 'credit',
      category: 'waste_sale',
      description: 'Deposit 50Kg Kulit Mangga',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    WalletTransaction(
      id: 'wt_002',
      userId: 'u1',
      amount: 12500,
      type: 'debit',
      category: 'withdrawal',
      description: 'Konversi ke Bioetanol Hub',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    WalletTransaction(
      id: 'wt_003',
      userId: 'u1',
      amount: 8200,
      type: 'credit',
      category: 'bonus',
      description: 'Bonus Misi Penjaga Energi',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
    ),
    WalletTransaction(
      id: 'wt_004',
      userId: 'u1',
      amount: 35000,
      type: 'credit',
      category: 'waste_sale',
      description: 'Deposit 30Kg Jeruk',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    WalletTransaction(
      id: 'wt_005',
      userId: 'u1',
      amount: 250000,
      type: 'debit',
      category: 'withdrawal',
      description: 'Withdrawal ke Bank BCA',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    WalletTransaction(
      id: 'wt_006',
      userId: 'u1',
      amount: 15000,
      type: 'credit',
      category: 'bonus',
      description: 'Bonus Aktivitas Mingguan',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // ─── Mock Waste Items ───
  final List<WasteItem> _mockWasteItems = [
    WasteItem(
      id: 'wi_001',
      userId: 'u1',
      wasteType: 'fruit',
      condition: 'Overripe',
      recommendedProcess: 'Bioethanol',
      estimatedValue: 50000,
      weightKg: 50,
      energyPotentialKwh: 12.5,
      description: 'Kulit Mangga segar dari pasar',
      status: 'processed',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    WasteItem(
      id: 'wi_002',
      userId: 'u1',
      wasteType: 'fruit',
      condition: 'Light Rot',
      recommendedProcess: 'Biogas',
      estimatedValue: 35000,
      weightKg: 30,
      energyPotentialKwh: 8.2,
      description: 'Jeruk busuk ringan',
      status: 'collected',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    WasteItem(
      id: 'wi_003',
      userId: 'u1',
      wasteType: 'vegetable',
      condition: 'Overripe',
      recommendedProcess: 'Bioethanol',
      estimatedValue: 28000,
      weightKg: 25,
      energyPotentialKwh: 6.8,
      description: 'Pulp Wortel dari industri jus',
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    WasteItem(
      id: 'wi_004',
      userId: 'u1',
      wasteType: 'fruit',
      condition: 'Heavy Rot',
      recommendedProcess: 'Biogas',
      estimatedValue: 15000,
      weightKg: 20,
      energyPotentialKwh: 5.0,
      description: 'Nanas busuk berat',
      status: 'processed',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    WasteItem(
      id: 'wi_005',
      userId: 'u1',
      wasteType: 'vegetable',
      condition: 'Light Rot',
      recommendedProcess: 'Biogas',
      estimatedValue: 22000,
      weightKg: 18,
      energyPotentialKwh: 4.5,
      description: 'Daun Singkong sisa panen',
      status: 'collected',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
    if (diff.inDays == 1) return 'Kemarin';
    return '${diff.inDays} hari yang lalu';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Aktivitas',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.greenCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.calendar, color: AppColors.lime, size: 12),
                      const SizedBox(width: 6),
                      Text(
                        'Mei 2026',
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.limeDark,
                unselectedLabelColor: AppColors.muted,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Transaksi'),
                  Tab(text: 'Sampah'),
                ],
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionsTab(),
                _buildWasteTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _mockTransactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final tx = _mockTransactions[index];
        final isPositive = tx.type == 'credit';

        IconData icon;
        Color iconColor;
        switch (tx.category) {
          case 'waste_sale':
            icon = FontAwesomeIcons.arrowDown;
            iconColor = AppColors.lime;
            break;
          case 'withdrawal':
            icon = FontAwesomeIcons.arrowUp;
            iconColor = AppColors.muted;
            break;
          case 'bonus':
            icon = FontAwesomeIcons.bolt;
            iconColor = AppColors.warning;
            break;
          default:
            icon = FontAwesomeIcons.clock;
            iconColor = AppColors.muted;
        }

        return _buildActivityCard(
          icon: icon,
          iconColor: iconColor,
          iconBgColor: isPositive
              ? AppColors.lime.withValues(alpha: 0.1)
              : const Color(0xFF1A1A1A),
          title: tx.description,
          subtitle: _formatTimeAgo(tx.createdAt),
          trailing: '${isPositive ? "+" : "-"}${tx.amount.toStringAsFixed(0)} EC',
          trailingColor: isPositive ? AppColors.lime : AppColors.danger,
        );
      },
    );
  }

  Widget _buildWasteTab() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _mockWasteItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _mockWasteItems[index];

        IconData icon;
        Color iconColor;
        String statusLabel;
        Color statusColor;
        switch (item.status) {
          case 'processed':
            icon = FontAwesomeIcons.recycle;
            iconColor = AppColors.lime;
            statusLabel = 'Diproses';
            statusColor = AppColors.lime;
            break;
          case 'collected':
            icon = FontAwesomeIcons.truck;
            iconColor = AppColors.warning;
            statusLabel = 'Dijemput';
            statusColor = AppColors.warning;
            break;
          default:
            icon = FontAwesomeIcons.hourglassHalf;
            iconColor = AppColors.muted;
            statusLabel = 'Menunggu';
            statusColor = AppColors.muted;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.greenCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
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
                      '${item.wasteType == 'fruit' ? 'Buah' : 'Sayur'} — ${item.condition}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _smallBadge(
                          item.recommendedProcess,
                          AppColors.greenDeep,
                          AppColors.white,
                        ),
                        const SizedBox(width: 6),
                        _smallBadge(
                          statusLabel,
                          statusColor.withValues(alpha: 0.15),
                          statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.weightKg.toStringAsFixed(0)} Kg · ${_formatTimeAgo(item.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${item.estimatedValue.toStringAsFixed(0)} EC',
                    style: const TextStyle(
                      color: AppColors.lime,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.energyPotentialKwh.toStringAsFixed(1)} kWh',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String trailing,
    required Color trailingColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
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
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: TextStyle(
              color: trailingColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallBadge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
