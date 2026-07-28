import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class RecruiterBottomNav extends StatelessWidget {
  final int currentIndex;
  const RecruiterBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/home/recruiter', '/recruiter/my-jobs', '/recruiter/applications', '/settings'];

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
        BottomNavigationBarItem(icon: Icon(Icons.campaign_outlined), activeIcon: Icon(Icons.campaign, color: AppColors.deepBlue), label: 'Mes annonces'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment, color: AppColors.deepBlue), label: 'Candidatures'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings, color: AppColors.deepBlue), label: 'Paramètres'),
      ],
    );
  }
}
