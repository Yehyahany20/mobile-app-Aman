import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/providers/analysis_provider.dart';
import '../analysis/analysis_result_screen.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<AnalysisProvider>(context).history;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.historyTitle),
      ),
      body: history.isEmpty
          ? const Center(child: Text("لا توجد سجلات فحص سابقة"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: item.isScam ? AppColors.danger.withOpacity(0.15) : AppColors.safe.withOpacity(0.15),
                      child: Icon(
                        item.isScam ? Icons.warning_amber_rounded : Icons.verified_user,
                        color: item.isScam ? AppColors.danger : AppColors.safe,
                      ),
                    ),
                    title: Text(item.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.conversationText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "اللهجة: ${item.dialect} • ${item.timestamp.hour}:${item.timestamp.minute}",
                          style: const TextStyle(fontSize: 11, color: Colors.black45),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "${item.riskScore.toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: item.isScam ? AppColors.danger : AppColors.safe,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AnalysisResultScreen(result: item)),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
