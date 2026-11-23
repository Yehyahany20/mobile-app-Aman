class AnalysisResult {
  final String id;
  final String conversationText;
  final bool isScam;
  final double riskScore; // 0.0 - 100.0
  final String category;
  final String dialect;
  final double arabertScore;
  final double mdebertaScore;
  final double setfitScore;
  final double gbmScore;
  final int urgencyScore;
  final int financialPressureScore;
  final int threatScore;
  final int impersonationScore;
  final DateTime timestamp;

  AnalysisResult({
    required this.id,
    required this.conversationText,
    required this.isScam,
    required this.riskScore,
    required this.category,
    required this.dialect,
    required this.arabertScore,
    required this.mdebertaScore,
    required this.setfitScore,
    required this.gbmScore,
    required this.urgencyScore,
    required this.financialPressureScore,
    required this.threatScore,
    required this.impersonationScore,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationText': conversationText,
    'isScam': isScam,
    'riskScore': riskScore,
    'category': category,
    'dialect': dialect,
    'arabertScore': arabertScore,
    'mdebertaScore': mdebertaScore,
    'setfitScore': setfitScore,
    'gbmScore': gbmScore,
    'urgencyScore': urgencyScore,
    'financialPressureScore': financialPressureScore,
    'threatScore': threatScore,
    'impersonationScore': impersonationScore,
    'timestamp': timestamp.toIso8601String(),
  };

  factory AnalysisResult.fromJson(Map<String, dynamic> json) => AnalysisResult(
    id: json['id'],
    conversationText: json['conversationText'],
    isScam: json['isScam'],
    riskScore: (json['riskScore'] as num).toDouble(),
    category: json['category'],
    dialect: json['dialect'],
    arabertScore: (json['arabertScore'] as num).toDouble(),
    mdebertaScore: (json['mdebertaScore'] as num).toDouble(),
    setfitScore: (json['setfitScore'] as num).toDouble(),
    gbmScore: (json['gbmScore'] as num).toDouble(),
    urgencyScore: json['urgencyScore'] ?? 0,
    financialPressureScore: json['financialPressureScore'] ?? 0,
    threatScore: json['threatScore'] ?? 0,
    impersonationScore: json['impersonationScore'] ?? 0,
    timestamp: DateTime.parse(json['timestamp']),
  );
}
