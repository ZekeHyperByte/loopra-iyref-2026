import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../services/ai_classification_service.dart';
import 'scan_result_screen.dart';

class WasteUploadScreen extends StatefulWidget {
  const WasteUploadScreen({super.key});

  @override
  State<WasteUploadScreen> createState() => _WasteUploadScreenState();
}

class _WasteUploadScreenState extends State<WasteUploadScreen>
    with SingleTickerProviderStateMixin {
  File? _selectedImage;
  bool _isScanning = false;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    AIClassificationService.resetScript();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, maxWidth: 1200);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _startScan() {
    setState(() => _isScanning = true);

    // Show the process selection dialog after the scan animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _showProcessSelectionDialog();
      }
    });
  }

  void _showProcessSelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: AppColors.lime, width: 1),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pilih Proses Konversi Energi',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Simulasikan hasil klasifikasi berdasarkan jenis proses yang diinginkan:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildProcessOption(
                icon: FontAwesomeIcons.flask,
                title: 'Simulasi Bio-Ethanol',
                subtitle: 'Cocok untuk buah-buahan dengan kandungan gula tinggi (Jeruk, Mangga, Pisang)',
                color: const Color(0xFF3B82F6),
                onTap: () => _onProcessSelected('Bioethanol'),
              ),
              const SizedBox(height: 12),
              _buildProcessOption(
                icon: FontAwesomeIcons.fire,
                title: 'Simulasi Bio-Gas',
                subtitle: 'Cocok untuk limbah organik umum (Sayuran, campuran) melalui anaerobic digestion',
                color: const Color(0xFFF97316),
                onTap: () => _onProcessSelected('Biogas'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              color: color.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _onProcessSelected(String processType) async {
    Navigator.pop(context); // Close the bottom sheet

    final result = await AIClassificationService.classifyWasteByProcess(processType);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(
            wasteType: result['wasteType'] ?? 'fruit',
            specificType: result['specificType'] ?? 'Jeruk',
            condition: result['condition'] ?? 'Overripe',
            grade: result['grade'] ?? 'A',
            recommendedProcess: result['recommendedProcess'] ?? 'Bioethanol',
            estimatedValuePerKg: (result['estimatedValuePerKg'] ?? 2500.0).toDouble(),
            energyPotentialKwh: (result['energyPotentialKwh'] ?? 24.0).toDouble(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameSize = (size.width * 0.65).clamp(200.0, 320.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_selectedImage != null)
            Image.file(_selectedImage!, fit: BoxFit.cover)
          else
            Container(color: Colors.black),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.4)],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topButton(FontAwesomeIcons.arrowLeft, () => Navigator.pop(context)),
                  _topButton(FontAwesomeIcons.circleInfo, () {}),
                ],
              ),
            ),
          ),
          if (_selectedImage != null && !_isScanning)
            Center(
              child: SizedBox(
                width: frameSize,
                height: frameSize,
                child: CustomPaint(painter: ScanFramePainter()),
              ),
            ),
          if (_isScanning)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Center(
                  child: SizedBox(
                    width: frameSize,
                    height: frameSize,
                    child: Stack(
                      children: [
                        CustomPaint(painter: ScanFramePainter(), size: Size(frameSize, frameSize)),
                        Positioned(
                          top: frameSize * 0.15 + (_scanController.value * frameSize * 0.7),
                          left: 0,
                          right: 0,
                          child: Container(height: 2, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isScanning) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text('AI Cek Sampah', style: TextStyle(color: AppColors.white, fontSize: 14)),
                    ),
                    const SizedBox(height: 20),
                  ] else ...[
                    const Text(
                      'Menganalisis limbah...',
                      style: TextStyle(color: AppColors.lime, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.greenDeep,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(FontAwesomeIcons.images, color: AppColors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 24),
                      if (!_isScanning)
                        GestureDetector(
                          onTap: _startScan,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: AppColors.limeGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: AppColors.lime.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 4),
                              ],
                            ),
                            child: const Icon(FontAwesomeIcons.magnifyingGlass, color: AppColors.white, size: 28),
                          ),
                        )
                      else
                        const SizedBox(
                          width: 72,
                          height: 72,
                          child: CircularProgressIndicator(color: AppColors.lime, strokeWidth: 4),
                        ),
                      const SizedBox(width: 24),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: const Icon(FontAwesomeIcons.bolt, color: AppColors.warning, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}

class ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cornerLength = size.width * 0.12;

    canvas.drawLine(const Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, cornerLength), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
