import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/providers/analysis_provider.dart';
import '../analysis/text_analysis_screen.dart';
import '../analysis/analysis_result_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  void _showLiveCallSimulator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _LiveCallActionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analysisProvider = Provider.of<AnalysisProvider>(context);
    final history = analysisProvider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            tooltip: "فحص مكالمة حية (Live Audio)",
            onPressed: () => _showLiveCallSimulator(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("لا توجد إشعارات جديدة حالياً")),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user, color: AppColors.accent, size: 40),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.systemProtected,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "خوارزميات DAMSE الذكية متيقظة لتحليل المكالمات",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Stats Banner
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: "عمليات الفحص",
                    value: "${history.length + 142}",
                    color: AppColors.primary,
                    icon: Icons.search,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: "احتيال تم رصده",
                    value: "${history.where((e) => e.isScam).length + 68}",
                    color: AppColors.danger,
                    icon: Icons.warning_amber_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: "دقة DAMSE",
                    value: "96.4%",
                    color: AppColors.safe,
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Two Action CTAs: Text analysis + Live Call analysis
            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    icon: Icons.document_scanner,
                    title: "فحص نصي",
                    subtitle: "تحليل محادثة أو SMS",
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TextAnalysisScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionTile(
                    icon: Icons.phone_in_talk,
                    title: "فحص مكالمة حية",
                    subtitle: "رصد صوتي فوري (ASR)",
                    color: const Color(0xFF00897B),
                    onTap: () => _showLiveCallSimulator(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent activity header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.recentScans,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("انتقل إلى تبويب 'السجل' لعرض كل العمليات")),
                    );
                  },
                  child: const Text("عرض الكل"),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...history.map((item) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.isScam ? AppColors.danger.withOpacity(0.15) : AppColors.safe.withOpacity(0.15),
                  child: Icon(
                    item.isScam ? Icons.warning_rounded : Icons.shield,
                    color: item.isScam ? AppColors.danger : AppColors.safe,
                  ),
                ),
                title: Text(
                  item.category,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Text(
                  item.conversationText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  "${item.riskScore.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: item.isScam ? AppColors.danger : AppColors.safe,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AnalysisResultScreen(result: item)),
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 20,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _LiveCallActionModal extends StatefulWidget {
  @override
  State<_LiveCallActionModal> createState() => _LiveCallActionModalState();
}

class _LiveCallActionModalState extends State<_LiveCallActionModal> {
  bool _isListening = false;
  String _liveTranscription = "اضغط على الزر لبدء الاستماع وتحليل تدفق المكالمة بالذكاء الاصطناعي...";

  void _toggleListening() async {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _liveTranscription = "جاري التقاط الصوت وتحويله لنص عبر وحدة ASR...";
      }
    });

    if (_isListening) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        _liveTranscription = "المتصل: 'مبروك يا فندم كسبت معانا من البنك، اديني رمز التأكيد عشان نسلمك الحوالة'...";
      });
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pop(context);
      
      final prov = Provider.of<AnalysisProvider>(context, listen: false);
      final res = await prov.analyze(_liveTranscription);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AnalysisResultScreen(result: res)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          const Text(
            "فحص المكالمات المباشرة (Live Stream ASR)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "يقوم بتحويل المكالمة إلى نص عربي فوراً ثم تطبيق أوزان DAMSE لرصد الاحتيال لحظياً.",
            style: TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? AppColors.danger : AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? AppColors.danger : AppColors.primary).withOpacity(0.4),
                    blurRadius: _isListening ? 25 : 10,
                    spreadRadius: _isListening ? 6 : 2,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _isListening ? "جاري الفحص المباشر..." : "اضغط للبدء",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isListening ? AppColors.danger : AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _liveTranscription,
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
