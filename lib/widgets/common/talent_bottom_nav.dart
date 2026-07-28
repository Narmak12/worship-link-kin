import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class TalentBottomNav extends StatelessWidget {
  final int currentIndex;
  const TalentBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/home/talent', '/calendar', '/talent/applications', '/settings'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        context.go(_routes[index]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home, color: AppColors.deepBlue), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today, color: AppColors.deepBlue), label: 'Calendrier'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment, color: AppColors.deepBlue), label: 'Candidatures'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings, color: AppColors.deepBlue), label: 'Paramètres'),
      ],
    );
  }
}
