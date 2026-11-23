import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/theme_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("التفضيلات والمظهر", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
                  title: const Text(AppStrings.darkMode),
                  value: themeProvider.isDarkMode,
                  onChanged: (val) => themeProvider.toggleTheme(),
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active, color: AppColors.primary),
                  title: const Text(AppStrings.notifications),
                  value: true,
                  onChanged: (val) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("عن المشروع والفريق", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "نظام أمان (Aman Vishing Detection)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                  ),
                  const SizedBox(height: 6),
                  const Text("إطار عمل متعدد الخوارزميات لرصد مكالمات الاحتيال الصوتي العربي بالاعتماد على إطار DAMSE."),
                  const SizedBox(height: 12),
                  const Divider(),
                  const Text(
                    "المشرف الأكاديمي:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const Text("د. محمود منير (Dr. Mahmoud Mounir)"),
                  const SizedBox(height: 10),
                  const Text(
                    "فريق العمل:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text("1. يحيى هاني (Yehya Hany)"),
                  const Text("2. سالي مدحت (Sally Medhat)"),
                  const Text("3. نرمين وجدي (Nermeen Wagdy)"),
                  const Text("4. جنى ماهر (Jana Maher)"),
                  const Text("5. عمر صلاح (Omar Salah)"),
                  const Text("6. مصطفى سعيد (Mostafa Saeed)"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
