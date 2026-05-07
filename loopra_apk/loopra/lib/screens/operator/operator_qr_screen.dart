import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/demo_state.dart';

class OperatorQrScreen extends StatelessWidget {
  final WasteSubmission submission;

  const OperatorQrScreen({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    final qrData = jsonEncode({
      'submissionId': submission.id,
      'amount': submission.finalTotal.toStringAsFixed(0),
      'seller': submission.sellerName,
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
        ),
        title: const Text('QR Pembayaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildQrCard(qrData),
            const SizedBox(height: 16),
            Text(
              'Scan QR ini di aplikasi penjual untuk menerima pembayaran',
              style: TextStyle(
                color: AppColors.muted.withValues(alpha: 0.8),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildDetailsCard(),
            const SizedBox(height: 32),
            if (submission.status == 'verified')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<DemoState>(context, listen: false)
                        .markAsPaid(submission.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pembayaran ditandai sudah dibayar!'),
                        backgroundColor: AppColors.limeDark,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(FontAwesomeIcons.circleCheck, size: 16),
                  label: const Text('Tandai Sudah Dibayar'),
                ),
              ),
            if (submission.status == 'paid')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lime.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lime.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.circleCheck, color: AppColors.lime, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Sudah Dibayar',
                      style: TextStyle(
                        color: AppColors.lime,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCard(String qrData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.greenCard,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              FontAwesomeIcons.recycle,
              color: AppColors.lime,
              size: 18,
            ),
          ),
          const SizedBox(height: 16),
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 280,
            backgroundColor: AppColors.white,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.greenDeep,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.greenCard,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Loopra Pay',
              style: TextStyle(
                color: AppColors.lime,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _detailRow(
            FontAwesomeIcons.user,
            'Penjual',
            submission.sellerName,
          ),
          const SizedBox(height: 16),
          _detailRow(
            FontAwesomeIcons.tag,
            'Jenis Limbah',
            submission.specificType,
          ),
          const SizedBox(height: 16),
          _detailRow(
            FontAwesomeIcons.moneyBill,
            'Harga per Kg',
            'Rp ${submission.finalPricePerKg.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 16),
          _detailRow(
            FontAwesomeIcons.weightHanging,
            'Berat',
            '${submission.weightKg.toStringAsFixed(1)} Kg',
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.muted.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(FontAwesomeIcons.coins, color: AppColors.lime, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Rp ${submission.finalTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.lime,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.muted, size: 14),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}