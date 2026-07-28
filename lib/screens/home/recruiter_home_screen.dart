import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/matching_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/recruiter_bottom_nav.dart';

class RecruiterHomeScreen extends ConsumerWidget {
  const RecruiterHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final pendingApps = ref.watch(recruiterApplicationsProvider).valueOrNull?.where((a) => a.isPending).length ?? 0;

    return AppScaffold(
      title: 'Tableau de bord',
      bottomNavigationBar: const RecruiterBottomNav(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profileAsync.when(
              data: (profile) => Text(
                'Bienvenue, ${profile?.churchName ?? profile?.fullName ?? ''}',
                style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepBlue),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 4),
            Text('Que Dieu bénisse votre ministère aujourd\'hui.', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateMuted)),
            const SizedBox(height: 24),
            AppButton(
              label: 'Publier une nouvelle annonce',
              icon: Icons.add_circle_outline,
              onPressed: () => context.push('/recruiter/create-job'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _DashboardCard(icon: Icons.assignment_outlined, label: 'Candidatures en attente', value: '$pendingApps', onTap: () => context.push('/recruiter/applications'))),
                const SizedBox(width: 12),
                Expanded(child: _DashboardCard(icon: Icons.campaign_outlined, label: 'Mes annonces', value: '', onTap: () => context.push('/recruiter/my-jobs'))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _DashboardCard(icon: Icons.search_outlined, label: 'Rechercher un talent', value: '', onTap: () => context.push('/search'))),
                const SizedBox(width: 12),
                Expanded(child: _DashboardCard(icon: Icons.favorite_outline, label: 'Mes favoris', value: '', onTap: () => context.push('/favorites'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DashboardCard({required this.icon, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [AppShadows.level1]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.gold, size: 22),
            const SizedBox(height: 10),
            if (value.isNotEmpty) Text(value, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
            Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
          ],
        ),
      ),
    );
  }
}
