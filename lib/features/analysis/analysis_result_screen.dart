import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/analysis_result.dart';

class AnalysisResultScreen extends StatelessWidget {
  final AnalysisResult result;
  const AnalysisResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isScam = result.isScam;
    final color = isScam ? AppColors.danger : AppColors.safe;

    return Scaffold(
      appBar: AppBar(
        title: const Text("تقرير التحليل (DAMSE)"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Verdict Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: isScam ? AppColors.dangerGradient : AppColors.safeGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    isScam ? Icons.warning_rounded : Icons.check_circle_outline,
                    size: 70,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isScam ? AppStrings.resultScam : AppStrings.resultSafe,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "مستوى الخطورة: ${result.riskScore.toStringAsFixed(1)}%",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Metadata card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildMetaRow("التصنيف:", result.category),
                    const Divider(),
                    _buildMetaRow("اللهجة المرصودة:", result.dialect),
                    const Divider(),
                    _buildMetaRow("معرف المكالمة:", result.id),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Conversation preview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("نص المحادثة المفحوص:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(result.conversationText, style: const TextStyle(fontSize: 13, height: 1.4)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // DAMSE breakdown title
            const Text(
              AppStrings.damseBreakdown,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildModelBar(AppStrings.arabertScore, result.arabertScore, AppColors.primary),
            _buildModelBar(AppStrings.mdebertaScore, result.mdebertaScore, const Color(0xFF5C6BC0)),
            _buildModelBar(AppStrings.setfitScore, result.setfitScore, const Color(0xFF26A69A)),
            _buildModelBar(AppStrings.gbmScore, result.gbmScore, const Color(0xFFFFA726)),

            const SizedBox(height: 16),
            const Text(
              "مؤشرات المخاطر المهيكلة (Features):",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildIndicatorBadge("الإلحاح", result.urgencyScore)),
                const SizedBox(width: 8),
                Expanded(child: _buildIndicatorBadge("الضغط المالي", result.financialPressureScore)),
                const SizedBox(width: 8),
                Expanded(child: _buildIndicatorBadge("التهديد", result.threatScore)),
                const SizedBox(width: 8),
                Expanded(child: _buildIndicatorBadge("انتحال صفة", result.impersonationScore)),
              ],
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("العودة للرئيسية"),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Widget _buildModelBar(String name, double score, Color barColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text("${(score * 100).toStringAsFixed(1)}%", style: TextStyle(fontSize: 12, color: barColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: score,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  static Widget _buildIndicatorBadge(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: value > 0 ? AppColors.danger.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: value > 0 ? AppColors.danger : Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: value > 0 ? AppColors.danger : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
