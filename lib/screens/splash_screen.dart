import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../models/enums.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _resolveDestination();
  }

  Future<void> _resolveDestination() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final user = ref.read(currentUserProvider);
    if (user == null) {
      context.go('/welcome');
      return;
    }

    try {
      final profile = await ref.read(userProfileProvider.future);
      if (!mounted) return;
      final isComplete = profile != null && profile.fullName.isNotEmpty && profile.fullName != 'Utilisateur';
      if (!isComplete) {
        context.go('/onboarding/role');
      } else {
        context.go(profile!.role == UserRole.talent ? '/home/talent' : '/home/recruiter');
      }
    } catch (_) {
      if (mounted) context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.church_outlined, size: 72, color: AppColors.gold),
            const SizedBox(height: 16),
            Text(
              'Worship Link Kin',
              style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3),
            ),
            const SizedBox(height: 8),
            Text(
              'Connectons les serviteurs aux églises',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold)),
            ),
          ],
        ),
      ),
    );
  }
}
