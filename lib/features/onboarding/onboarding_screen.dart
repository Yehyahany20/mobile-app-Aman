import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../home/main_wrapper_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "icon": Icons.security,
      "title": "حماية فورية من الاحتيال",
      "subtitle": "نظام أمان يقوم برصد المكالمات الاحتيالية والتصيد الصوتي (Vishing) باللغة العربية بدقة فائقة.",
    },
    {
      "icon": Icons.auto_awesome,
      "title": "إطار عمل DAMSE المبتكر",
      "subtitle": "دمج 5 نماذج ذكاء اصطناعي (AraBERT, mDeBERTa, SetFit, GBM) مع توازن دقيق للهجات العربية المتعددة.",
    },
    {
      "icon": Icons.verified_user,
      "title": "أمان وخصوصية مطلقة",
      "subtitle": "تنبيهات فورية واضحة ومؤشرات رقمية لمستوى الخطورة تحمي حساباتك ومعلوماتك البنكية الحساسة.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainWrapperScreen()),
                    );
                  },
                  child: const Text("تخطي", style: TextStyle(fontSize: 16, color: AppColors.primary)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (idx) => setState(() => _currentIndex = idx),
                  itemBuilder: (context, idx) {
                    final p = _pages[idx];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(p["icon"] as IconData, size: 70, color: AppColors.primary),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          p["title"] as String,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p["subtitle"] as String,
                          style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? AppColors.accent : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainWrapperScreen()),
                      );
                    }
                  },
                  child: Text(
                    _currentIndex == _pages.length - 1 ? "ابدأ الاستخدام" : "التالي",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
