import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../seller/weight_price_screen.dart';

class ScanResultScreen extends StatelessWidget {
  final String wasteType;
  final String specificType;
  final String condition;
  final String grade;
  final String recommendedProcess;
  final double estimatedValuePerKg;
  final double energyPotentialKwh;

  const ScanResultScreen({
    super.key,
    this.wasteType = 'fruit',
    this.specificType = 'Jeruk',
    this.condition = 'Overripe',
    this.grade = 'A',
    this.recommendedProcess = 'Bioethanol',
    this.estimatedValuePerKg = 2500.0,
    this.energyPotentialKwh = 0.8,
  });

  Color get _gradeColor {
    switch (grade) {
      case 'A':
        return AppColors.lime;
      case 'B':
        return const Color(0xFFFBBF24);
      case 'C':
        return AppColors.danger;
      default:
        return AppColors.lime;
    }
  }

  String get _gradeDescription {
    switch (grade) {
      case 'A':
        return 'Klasifikasi Grade A mengidentifikasi bio-asset berkualitas tinggi dengan kadar air rendah dan profil nutrisi optimal untuk produksi bioethanol.';
      case 'B':
        return 'Klasifikasi Grade B mengidentifikasi bio-asset dengan karakteristik kadar air (moisture content) menengah dan profil nutrisi yang cukup baik untuk produksi bioethanol.';
      case 'C':
        return 'Klasifikasi Grade C mengidentifikasi bio-asset yang sudah mengalami degradasi signifikan, paling cocok untuk produksi biogas melalui anaerobic digestion.';
      default:
        return 'Klasifikasi limbah organik untuk konversi energi terbarukan.';
    }
  }

  String get _estYield {
    switch (grade) {
      case 'A':
        return '1.8 L';
      case 'B':
        return '1.2 L';
      case 'C':
        return '0.6 L';
      default:
        return '1.0 L';
    }
  }

  String get _energyPot {
    switch (grade) {
      case 'A':
        return '42.1 MJ';
      case 'B':
        return '35.4 MJ';
      case 'C':
        return '22.8 MJ';
      default:
        return '30.0 MJ';
    }
  }

  String get _waterContent {
    switch (grade) {
      case 'A':
        return '8%';
      case 'B':
        return '12%';
      case 'C':
        return '25%';
      default:
        return '15%';
    }
  }

  String get _purity {
    switch (grade) {
      case 'A':
        return '99%';
      case 'B':
        return '98%';
      case 'C':
        return '92%';
      default:
        return '95%';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: AppColors.greenDeep,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.bagShopping,
                          size: 80,
                          color: AppColors.lime.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Limbah $specificType',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.5),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: CustomPaint(
                      painter: _ResultScanFramePainter(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: _gradeColor, width: 2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'GRADE $grade',
                        style: TextStyle(
                          color: _gradeColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Limbah Hortikultura ($specificType)',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _gradeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        recommendedProcess,
                        style: TextStyle(
                          color: _gradeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.lime.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              FontAwesomeIcons.atom,
                              color: AppColors.lime,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(text: _gradeDescription),
                                  TextSpan(
                                    text: ' lihat lebih detail',
                                    style: TextStyle(
                                      color: AppColors.lime,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Industrial Assay Data',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _assayCard(FontAwesomeIcons.seedling, 'Est. Yield: $_estYield', '(Crude Ethanol)', width: 120),
                          const SizedBox(width: 8),
                          _assayCard(FontAwesomeIcons.flask, 'Energy Pot.: $_energyPot', '($recommendedProcess)', width: 120),
                          const SizedBox(width: 8),
                          _assayCard(FontAwesomeIcons.industry, 'Water: $_waterContent', '(Kadar Air)', width: 100),
                          const SizedBox(width: 8),
                          _assayCard(FontAwesomeIcons.recycle, 'Purity: $_purity', '(Kemurnian)', width: 100),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WeightPriceScreen(
                                wasteType: wasteType,
                                specificType: specificType,
                                condition: condition,
                                grade: grade,
                                recommendedProcess: recommendedProcess,
                                estimatedValuePerKg: estimatedValuePerKg,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(FontAwesomeIcons.scaleBalanced),
                        label: const Text('Masukkan Berat & Lihat Harga'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
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
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }

  Widget _assayCard(IconData icon, String value, String label, {required double width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greenCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.lime, size: 16),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;

    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
