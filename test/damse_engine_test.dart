import 'package:flutter_test/flutter_test.dart';
import 'package:aman_app/data/models/analysis_result.dart';
import 'package:aman_app/data/services/damse_service.dart';

void main() {
  test('DAMSE Engine detects scam text properly', () async {
    final result = await DamseEngineService.analyzeConversation('مبروك كسبت جائزة 100 ألف');
    expect(result.isScam, isTrue);
    expect(result.riskScore, greaterThan(50.0));
    expect(result.category, contains('يانصيب'));
  });

  test('DAMSE Engine recognizes legitimate conversation', () async {
    final result = await DamseEngineService.analyzeConversation('السلام عليكم موعد صيانة الجهاز غداً');
    expect(result.isScam, isFalse);
    expect(result.riskScore, lessThan(50.0));
  });
}
