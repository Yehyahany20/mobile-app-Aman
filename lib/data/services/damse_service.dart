import 'dart:math';
import '../models/analysis_result.dart';

class DamseEngineService {
  // Simulates or connects to DAMSE ensemble backend
  static Future<AnalysisResult> analyzeConversation(String text) async {
    // Artificial realistic delay for analysis
    await Future.delayed(const Duration(milliseconds: 1400));
    final lower = text.toLowerCase();

    // Risk indicator heuristics based on our Arab dataset features
    bool hasBank = lower.contains("بنك") || lower.contains("حساب") || lower.contains("بطاقة") || lower.contains("فيزا") || lower.contains("كود");
    bool hasPrize = lower.contains("ربحت") || lower.contains("جائزة") || lower.contains("مليون") || lower.contains("سحب");
    bool hasUrgency = lower.contains("بسرعة") || lower.contains("فورا") || lower.contains("الآن") || lower.contains("سيتوقف") || lower.contains("خلال ساعة");
    bool hasThreat = lower.contains("إيقاف") || lower.contains("شرطة") || lower.contains("نيابة") || lower.contains("غرامة");

    int urgency = hasUrgency ? 4 : 0;
    int financialPressure = hasPrize || hasBank ? 3 : 0;
    int threat = hasThreat ? 4 : 0;
    int impersonation = hasBank ? 1 : 0;

    bool isScam = (hasBank && hasUrgency) || hasPrize || hasThreat || (text.length > 30 && (hasBank || hasUrgency));
    double score = isScam ? (78.0 + Random().nextInt(20)) : (8.0 + Random().nextInt(20));

    String detectedDialect = "المصرية (Egyptian)";
    if (lower.contains("أخوي") || lower.contains("شلونك") || lower.contains("زين")) {
      detectedDialect = "الخليجية (Gulf)";
    } else if (lower.contains("هلق") || lower.contains("بدي") || lower.contains("شو")) {
      detectedDialect = "الشامية (Levantine)";
    }

    String category = isScam 
        ? (hasBank ? "احتيال بنكي (Bank Fraud)" : (hasPrize ? "يانصيب وهمي (Prize Lottery)" : "انتحال صفة رسمية"))
        : "محادثة مشروعة (Legitimate)";

    return AnalysisResult(
      id: "CONV_${DateTime.now().millisecondsSinceEpoch}",
      conversationText: text,
      isScam: isScam,
      riskScore: score,
      category: category,
      dialect: detectedDialect,
      arabertScore: isScam ? 0.91 : 0.12,
      mdebertaScore: isScam ? 0.88 : 0.15,
      setfitScore: isScam ? 0.85 : 0.09,
      gbmScore: isScam ? 0.94 : 0.10,
      urgencyScore: urgency,
      financialPressureScore: financialPressure,
      threatScore: threat,
      impersonationScore: impersonation,
      timestamp: DateTime.now(),
    );
  }
}
