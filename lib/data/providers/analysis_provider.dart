import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../services/damse_service.dart';

class AnalysisProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AnalysisResult? _currentResult;
  AnalysisResult? get currentResult => _currentResult;

  final List<AnalysisResult> _history = [
    AnalysisResult(
      id: "CONV_SAMPLE_1",
      conversationText: "مبروك كسبت معانا مية ألف جنيه! ابعت رقم الكارت والـ OTP بسرعة عشان نأكد استلام الجايزة",
      isScam: true,
      riskScore: 94.5,
      category: "يانصيب وجوائز (Prize Lottery)",
      dialect: "المصرية (Egyptian)",
      arabertScore: 0.96,
      mdebertaScore: 0.92,
      setfitScore: 0.89,
      gbmScore: 0.95,
      urgencyScore: 4,
      financialPressureScore: 3,
      threatScore: 0,
      impersonationScore: 1,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AnalysisResult(
      id: "CONV_SAMPLE_2",
      conversationText: "السلام عليكم يا فندم، أنا فني صيانة التكييف وميعادنا اليوم الساعة 2، برجاء التأكيد",
      isScam: false,
      riskScore: 12.0,
      category: "خدمات مشروعة (Service Legitimate)",
      dialect: "الفصحى (MSA)",
      arabertScore: 0.10,
      mdebertaScore: 0.14,
      setfitScore: 0.08,
      gbmScore: 0.05,
      urgencyScore: 0,
      financialPressureScore: 0,
      threatScore: 0,
      impersonationScore: 0,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    )
  ];

  List<AnalysisResult> get history => _history;

  Future<AnalysisResult> analyze(String text) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await DamseEngineService.analyzeConversation(text);
      _currentResult = res;
      _history.insert(0, res);
      _isLoading = false;
      notifyListeners();
      return res;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearCurrent() {
    _currentResult = null;
    notifyListeners();
  }
}
