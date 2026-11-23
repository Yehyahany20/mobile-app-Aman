import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navStats),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "نظرة عامة على قاعدة البيانات (DAMSE Dataset)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Column(
                children: [
                  _StatItem(label: "إجمالي المحادثات المسجلة", value: "448 محادثة"),
                  Divider(),
                  _StatItem(label: "محادثات احتيالية (Scam)", value: "246 (55%)", color: AppColors.danger),
                  Divider(),
                  _StatItem(label: "محادثات مشروعة (Legitimate)", value: "202 (45%)", color: AppColors.safe),
                  Divider(),
                  _StatItem(label: "عدد اللهجات المغطاة", value: "9 لهجات عربية"),
                  Divider(),
                  _StatItem(label: "الفئات المصنفة", value: "23 فئة احتيال وتواصل"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "توزيع اللهجات العربية في التدريب:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDialectBar("المصرية (Egyptian)", 83, 448),
            _buildDialectBar("الفصحى (MSA)", 93, 448),
            _buildDialectBar("الخليجية (Gulf)", 72, 448),
            _buildDialectBar("الأردنية (Jordanian)", 66, 448),
            _buildDialectBar("لهجات أخرى (عراقي، سوداني، شامي...)", 134, 448),
            const SizedBox(height: 24),
            const Text(
              "كفاءة النماذج (Study Evaluation):",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _StatItem(label: "Accuracy (الدقة الإجمالية)", value: "96.2%"),
                    Divider(),
                    _StatItem(label: "Precision (ضبط كشف الاحتيال)", value: "95.8%"),
                    Divider(),
                    _StatItem(label: "Recall (نسبة التقاط الاحتيال)", value: "97.1%"),
                    Divider(),
                    _StatItem(label: "F1-Score", value: "96.4%"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDialectBar(String dialect, int count, int total) {
    final pct = count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dialect, style: const TextStyle(fontSize: 13)),
              Text("$count ($pct%)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: pct,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _StatItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
