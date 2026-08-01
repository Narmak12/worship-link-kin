import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/dev_config.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_client.dart';
import '../widgets/common/app_button.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _continueDevMode() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final session = await ref.read(authServiceProvider).signInAnonymously();
      if (session == null) {
        setState(() => _error = 'Connexion anonyme indisponible — active-la dans Supabase (Authentication > Providers > Anonymous).');
        return;
      }
      final userId = session.user.id;
      final existing = await ref.read(authServiceProvider).fetchProfile(userId);
      if (existing == null) {
        await supabase.from('profiles').insert({
          'id': userId,
          'role': 'talent',
          'full_name': 'Utilisateur',
          'phone': 'dev-${userId.substring(0, 8)}',
          'city': 'Kinshasa',
        });
      }
      ref.invalidate(userProfileProvider);
      if (!mounted) return;
      context.go('/onboarding/role');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.deepBlue, borderRadius: BorderRadius.circular(28)),
                child: const Icon(Icons.church_outlined, size: 48, color: AppColors.gold),
              ),
              const SizedBox(height: 24),
              Text('Worship Link Kin', style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.deepBlue, letterSpacing: -0.5), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Connectons les serviteurs aux églises de Kinshasa',
                style: GoogleFonts.inter(fontSize: 15, color: AppColors.slateMuted),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              if (kDevMode) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                  child: Text('MODE DÉVELOPPEMENT — SMS désactivé', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.deepBlue, letterSpacing: 0.3)),
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: 'Continuer',
                  icon: Icons.arrow_forward_rounded,
                  loading: _loading,
                  onPressed: _continueDevMode,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.softError), textAlign: TextAlign.center),
                ],
              ] else ...[
                Text('Vous êtes...', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.deepBlue)),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Un talent (musicien, artiste de culte)',
                  icon: Icons.music_note_outlined,
                  onPressed: () => context.push('/auth/phone', extra: 'talent'),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Une église',
                  icon: Icons.church_outlined,
                  variant: AppButtonVariant.outline,
                  onPressed: () => context.push('/auth/phone', extra: 'recruiter'),
                ),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.push('/about'),
                child: Text('En savoir plus', style: GoogleFonts.inter(fontSize: 13, color: AppColors.gold, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
