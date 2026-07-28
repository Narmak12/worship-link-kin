import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/enums.dart';
import '../../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  void _select(BuildContext context, WidgetRef ref, UserRole role) {
    ref.read(onboardingStateProvider.notifier).state = ref.read(onboardingStateProvider).copyWith(selectedRole: role);
    context.go(role == UserRole.talent ? '/onboarding/talent-form' : '/onboarding/church-form');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final existingRole = ref.watch(onboardingStateProvider).selectedRole;

    // Si le rôle a déjà été choisi à l'étape précédente (écran de bienvenue), on saute directement.
    if (existingRole != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _select(context, ref, existingRole));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ton profil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tu es...', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
            const SizedBox(height: 20),
            _RoleCard(
              icon: Icons.music_note_outlined,
              title: 'Un talent',
              subtitle: 'Musicien, chantre, technicien, artiste de culte...',
              onTap: () => _select(context, ref, UserRole.talent),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              icon: Icons.church_outlined,
              title: 'Une église',
              subtitle: 'Tu recherches des serviteurs pour tes cultes et événements',
              onTap: () => _select(context, ref, UserRole.recruiter),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [AppShadows.level1]),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.goldMuted, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.deepBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.slateMuted),
          ],
        ),
      ),
    );
  }
}
