import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/demo_state.dart';
import 'operator_qr_screen.dart';

class OperatorVerifyScreen extends StatefulWidget {
  final WasteSubmission submission;

  const OperatorVerifyScreen({super.key, required this.submission});

  @override
  State<OperatorVerifyScreen> createState() => _OperatorVerifyScreenState();
}

class _OperatorVerifyScreenState extends State<OperatorVerifyScreen> {
  late double _pricePerKg;

  @override
  void initState() {
    super.initState();
    _pricePerKg = widget.submission.estimatedValuePerKg;
  }

  @override
  Widget build(BuildContext context) {
    final submission = widget.submission;
    final total = submission.weightKg * _pricePerKg;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
        ),
        title: const Text('Verifikasi Limbah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWasteInfoCard(submission),
            const SizedBox(height: 20),
            _buildPriceSection(submission, total),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _verifyAndNavigate(submission),
                icon: const Icon(FontAwesomeIcons.qrcode, size: 16),
                label: const Text('Setujui & Buat QR Pembayaran'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteInfoCard(WasteSubmission s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.greenDeep,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  FontAwesomeIcons.recycle,
                  color: AppColors.lime,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.sellerName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.specificType,
                      style: TextStyle(
                        color: AppColors.lime.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _infoRow(FontAwesomeIcons.tag, 'Jenis Limbah', s.wasteType),
          const SizedBox(height: 12),
          _infoRow(FontAwesomeIcons.droplet, 'Kondisi', s.condition),
          const SizedBox(height: 12),
          _infoRow(FontAwesomeIcons.award, 'Grade', s.grade),
          const SizedBox(height: 12),
          _infoRow(FontAwesomeIcons.weightHanging, 'Berat', '${s.weightKg.toStringAsFixed(1)} Kg'),
          const SizedBox(height: 12),
          _infoRow(FontAwesomeIcons.flask, 'Proses Rekomendasi', s.recommendedProcess),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.muted, size: 14),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(WasteSubmission s, double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tentukan Harga',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(FontAwesomeIcons.calculator, color: AppColors.muted, size: 14),
              const SizedBox(width: 6),
              const Text(
                'Estimasi harga per Kg',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const Spacer(),
              Text(
                'Rp ${s.estimatedValuePerKg.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Harga final per Kg: Rp ${_pricePerKg.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.lime,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
            value: _pricePerKg,
            min: (s.estimatedValuePerKg * 0.5),
            max: (s.estimatedValuePerKg * 1.5),
            divisions: 20,
            activeColor: AppColors.lime,
            inactiveColor: AppColors.greenPrimary,
            label: 'Rp ${_pricePerKg.toStringAsFixed(0)}',
            onChanged: (val) {
              setState(() {
                _pricePerKg = val;
              });
            },
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.greenDeep,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Rp ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.lime,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${s.weightKg.toStringAsFixed(1)} Kg  ×  Rp ${_pricePerKg.toStringAsFixed(0)}/Kg',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyAndNavigate(WasteSubmission submission) {
    Provider.of<DemoState>(context, listen: false)
        .verifySubmission(submission.id, _pricePerKg);

    final updatedSubmission = Provider.of<DemoState>(context, listen: false)
        .submissions
        .firstWhere((s) => s.id == submission.id);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OperatorQrScreen(submission: updatedSubmission),
        ),
      );
    }
  }
}