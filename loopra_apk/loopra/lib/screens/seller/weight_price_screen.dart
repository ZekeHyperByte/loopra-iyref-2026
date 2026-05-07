import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/demo_state.dart';
import 'qr_payment_screen.dart';

class WeightPriceScreen extends StatefulWidget {
  final String wasteType;
  final String specificType;
  final String condition;
  final String grade;
  final String recommendedProcess;
  final double estimatedValuePerKg;

  const WeightPriceScreen({
    super.key,
    required this.wasteType,
    required this.specificType,
    required this.condition,
    required this.grade,
    required this.recommendedProcess,
    required this.estimatedValuePerKg,
  });

  @override
  State<WeightPriceScreen> createState() => _WeightPriceScreenState();
}

class _WeightPriceScreenState extends State<WeightPriceScreen> {
  final _weightController = TextEditingController();
  double _weight = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  double get _estimatedTotal => _weight * widget.estimatedValuePerKg;

  String _formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _submit() {
    if (_weight <= 0) return;

    setState(() => _isSubmitting = true);

    final demo = context.read<DemoState>();
    final submission = WasteSubmission(
      id: 'WS${DateTime.now().millisecondsSinceEpoch}',
      sellerName: 'Budi Santoso',
      wasteType: widget.wasteType,
      specificType: widget.specificType,
      condition: widget.condition,
      grade: widget.grade,
      recommendedProcess: widget.recommendedProcess,
      weightKg: _weight,
      estimatedValuePerKg: widget.estimatedValuePerKg,
      createdAt: DateTime.now(),
    );

    demo.addSubmission(submission);

    setState(() => _isSubmitting = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const QRPaymentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Estimasi Harga'),
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClassificationCard(),
              const SizedBox(height: 24),
              _buildWeightInput(),
              const SizedBox(height: 24),
              _buildPriceBreakdown(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassificationCard() {
    final gradeColor = widget.grade.toUpperCase().contains('A')
        ? AppColors.lime
        : widget.grade.toUpperCase().contains('B')
            ? AppColors.warning
            : AppColors.danger;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lime.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.specificType,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: gradeColor),
                ),
                child: Text(
                  'GRADE ${widget.grade}',
                  style: TextStyle(
                    color: gradeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(FontAwesomeIcons.recycle, 'Tipe', widget.wasteType),
          const SizedBox(height: 10),
          _buildInfoRow(FontAwesomeIcons.droplet, 'Kondisi', widget.condition),
          const SizedBox(height: 10),
          _buildInfoRow(FontAwesomeIcons.flask, 'Proses', widget.recommendedProcess),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lime.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(FontAwesomeIcons.coins, color: AppColors.lime, size: 16),
                const SizedBox(width: 10),
                Text(
                  'Harga estimasi: ${_formatRupiah(widget.estimatedValuePerKg)}/Kg',
                  style: const TextStyle(
                    color: AppColors.lime,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.muted, size: 14),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Masukkan Berat Limbah',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Berat dalam kilogram (Kg)',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _weight > 0 ? AppColors.lime : const Color(0xFF2A2A2A),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Color(0xFF3A3A3A), fontSize: 32),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _weight = double.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.greenCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Kg',
                  style: TextStyle(
                    color: AppColors.lime,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [5, 10, 20, 50].map((w) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  _weightController.text = w.toString();
                  setState(() => _weight = w.toDouble());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.greenCard,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.lime.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '$w Kg',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    final isActive = _weight > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(color: AppColors.lime.withValues(alpha: 0.4))
            : null,
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'Berat',
            '${_weight.toStringAsFixed(1)} Kg',
            AppColors.white,
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            'Harga per Kg',
            _formatRupiah(widget.estimatedValuePerKg),
            AppColors.white,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFF2A2A2A)),
          ),
          _buildPriceRow(
            'Estimasi Total',
            _formatRupiah(_estimatedTotal),
            AppColors.lime,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, Color valueColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.muted,
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: isBold ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final isEnabled = _weight > 0 && !_isSubmitting;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _submit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.lime : AppColors.muted.withValues(alpha: 0.3),
          foregroundColor: isEnabled ? AppColors.limeDark : AppColors.muted,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          disabledBackgroundColor: AppColors.muted.withValues(alpha: 0.2),
          disabledForegroundColor: AppColors.muted,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.limeDark),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.paperPlane, size: 16),
                  const SizedBox(width: 10),
                  const Text(
                    'Kirim ke Titik Pengumpulan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}