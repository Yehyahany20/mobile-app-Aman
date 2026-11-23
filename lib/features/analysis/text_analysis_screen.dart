import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/providers/analysis_provider.dart';
import 'analysis_result_screen.dart';

class TextAnalysisScreen extends StatefulWidget {
  const TextAnalysisScreen({super.key});

  @override
  State<TextAnalysisScreen> createState() => _TextAnalysisScreenState();
}

class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
  final TextEditingController _textController = TextEditingController();

  final List<String> _samplePrompts = [
    "مبروك! كسبت معانا 100 ألف دينار من زين، عشان تستلم الجايزة حول ألفين دينار رسوم البنك فوراً",
    "السلام عليكم، أنا من البنك الأهلي، تم إيقاف بطاقتك الائتمانية. نرجو إرسال رمز التحقق OTP فوراً لتنشيطها",
    "ألو يا فندم، أنا فني صيانة التكييف وميعادنا اليوم الساعة 2، برجاء إطفاء التكييف قبل الوصول",
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _runAnalysis() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال نص المحادثة أولاً")),
      );
      return;
    }

    final provider = Provider.of<AnalysisProvider>(context, listen: false);
    try {
      final result = await provider.analyze(text);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AnalysisResultScreen(result: result)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ أثناء التحليل: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalysisProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.analysisTitle),
      ),
      body: provider.isLoading
          ? _buildLoadingState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "أدخل نص المكالمة أو المحادثة المشبوهة:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: AppStrings.enterTextHint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "أو جرب نماذج من قاعدة بيانات المشروع (Scam Dataset):",
                    style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _samplePrompts.map((s) => ActionChip(
                      label: Text(
                        s.length > 35 ? "${s.substring(0, 35)}..." : s,
                        style: const TextStyle(fontSize: 11),
                      ),
                      onPressed: () {
                        setState(() => _textController.text = s);
                      },
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.bolt),
                      label: const Text(AppStrings.btnStartScan, style: TextStyle(fontSize: 16)),
                      onPressed: _runAnalysis,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            AppStrings.scanInProgress,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "AraBERT • mDeBERTa • SetFit • GBM",
            style: TextStyle(fontSize: 13, color: AppColors.primary, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
