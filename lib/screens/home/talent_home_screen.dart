import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/talent_bottom_nav.dart';
import '../talent/jobs_feed_screen.dart';

class TalentHomeScreen extends StatelessWidget {
  const TalentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Annonces',
      body: JobsFeedScreen(),
      bottomNavigationBar: TalentBottomNav(currentIndex: 0),
    );
  }
}
