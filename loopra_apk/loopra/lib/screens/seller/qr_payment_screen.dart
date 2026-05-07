import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/demo_state.dart';
import 'payment_success_screen.dart';

class QRPaymentScreen extends StatefulWidget {
  const QRPaymentScreen({super.key});

  @override
  State<QRPaymentScreen> createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends State<QRPaymentScreen>
    with TickerProviderStateMixin {
  bool _isScanning = false;
  bool _showManualEntry = false;
  final _manualCodeController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  void _handleQRData(String data) {
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final submissionId = json['submissionId'] as String? ?? '';
      final amountFromQR = double.tryParse(json['amount']?.toString() ?? '0') ?? 0;

      final demo = context.read<DemoState>();
      final submission = demo.currentSellerSubmission;

      if (submission != null && submissionId.isNotEmpty) {
        // Verify using estimated price (simulation) or keep existing verified price
        if (submission.status != 'verified' && submission.status != 'paid') {
          demo.verifySubmission(submissionId, submission.estimatedValuePerKg);
        }
        demo.markAsPaid(submissionId);

        // Get the verified submission to ensure correct final amount
        final verified = demo.submissions.firstWhere((s) => s.id == submissionId);
        final actualAmount = verified.finalTotal > 0 ? verified.finalTotal : amountFromQR;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              amount: actualAmount,
              wasteType: verified.specificType,
              weightKg: verified.weightKg,
              grade: verified.grade,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('QR handling error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR code tidak valid'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  void _simulateScan() {
    final demo = context.read<DemoState>();
    final submission = demo.currentSellerSubmission;

    if (submission != null) {
      // Use estimatedTotal because toQRData() would give 0 (finalPricePerKg not set yet)
      final qrData = jsonEncode({
        'submissionId': submission.id,
        'amount': submission.estimatedTotal.toStringAsFixed(0),
        'seller': submission.sellerName,
        'type': submission.specificType,
      });
      _handleQRData(qrData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada submission aktif untuk disimulasikan'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  void _handleManualEntry() {
    final code = _manualCodeController.text.trim();
    if (code.isNotEmpty) {
      _handleQRData(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(_isScanning ? 'Scan QR' : 'Menunggu Verifikasi'),
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
          onPressed: _isScanning
              ? () => setState(() => _isScanning = false)
              : () => Navigator.pop(context),
        ),
      ),
      body: _isScanning ? _buildScanner() : _buildWaitingState(),
    );
  }

  Widget _buildWaitingState() {
    final submission = context.watch<DemoState>().currentSellerSubmission;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 24),
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lime.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.lime, width: 2),
                ),
                child: const Icon(
                  FontAwesomeIcons.clock,
                  color: AppColors.lime,
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Menunggu Verifikasi',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Limbah Anda sedang diverifikasi oleh operator\ndi titik pengumpulan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            if (submission != null) ...[
              Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Detail Pengiriman',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Pending',
                            style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(FontAwesomeIcons.recycle, 'Tipe', submission.specificType),
                    const SizedBox(height: 10),
                    _buildDetailRow(FontAwesomeIcons.weightHanging, 'Berat', '${submission.weightKg.toStringAsFixed(1)} Kg'),
                    const SizedBox(height: 10),
                    _buildDetailRow(FontAwesomeIcons.tag, 'Grade', submission.grade),
                    const SizedBox(height: 10),
                    _buildDetailRow(FontAwesomeIcons.flask, 'Proses', submission.recommendedProcess),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lime.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.lime.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.qrcode,
                      color: AppColors.lime,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Setelah verifikasi selesai,',
                    style: TextStyle(color: AppColors.muted, fontSize: 14),
                  ),
                  const Text(
                    'scan QR dari operator untuk menerima pembayaran',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _isScanning = true),
                icon: const Icon(FontAwesomeIcons.qrcode, size: 18),
                label: const Text('Scan QR Pembayaran'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() => _showManualEntry = !_showManualEntry),
              child: const Text(
                'Atau masukkan kode manual',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ),
            if (_showManualEntry) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _manualCodeController,
                      style: const TextStyle(color: AppColors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Masukkan kode verifikasi',
                        hintStyle: TextStyle(color: AppColors.muted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _handleManualEntry,
                      icon: const Icon(FontAwesomeIcons.arrowRight, color: AppColors.limeDark, size: 16),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
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

  Widget _buildScanner() {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) {
            final barcode = capture.barcodes.firstOrNull;
            if (barcode != null && barcode.rawValue != null) {
              _handleQRData(barcode.rawValue!);
            }
          },
        ),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.lime.withValues(alpha: 0.3), width: 4),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(FontAwesomeIcons.qrcode, color: AppColors.lime, size: 32),
                    const SizedBox(height: 12),
                    const Text(
                      'Arahkan kamera ke QR code\ndari operator untuk verifikasi pembayaran',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Simulation button for demo
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _simulateScan,
                    icon: const Icon(FontAwesomeIcons.wandMagicSparkles, size: 18),
                    label: const Text('Selesaikan Simulasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: AppColors.limeDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
