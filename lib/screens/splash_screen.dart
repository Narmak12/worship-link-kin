import 'dart:async';
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
  Timer? _failsafe;

  @override
  void initState() {
    super.initState();
    // Filet de sécurité ultime : quoi qu'il arrive, si on n'a pas navigué
    // après 10 secondes, on force le retour à l'accueil plutôt que de
    // laisser l'utilisateur bloqué indéfiniment sur ce spinner. Annulé dès
    // qu'une navigation réelle a lieu (voir _resolveDestination).
    _failsafe = Timer(const Duration(seconds: 10), () {
      if (mounted) context.go('/welcome');
    });
    _resolveDestination();
  }

  @override
  void dispose() {
    _failsafe?.cancel();
    super.dispose();
  }

  Future<void> _resolveDestination() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;

      final user = ref.read(currentUserProvider);
      if (user == null) {
        _failsafe?.cancel();
        if (mounted) context.go('/welcome');
        return;
      }

      final profile = await ref.read(userProfileProvider.future).timeout(
        const Duration(seconds: 8),
        onTimeout: () => throw Exception('timeout'),
      );
      if (!mounted) return;
      _failsafe?.cancel();
      final isComplete = profile != null && profile.fullName.isNotEmpty && profile.fullName != 'Utilisateur';
      if (!isComplete) {
        context.go('/onboarding/role');
      } else {
        context.go(profile!.role == UserRole.talent ? '/home/talent' : '/home/recruiter');
      }
    } catch (_) {
      // Quelle que soit l'erreur (réseau, session invalide, timeout...),
      // on ne laisse jamais l'utilisateur bloqué sur le splash.
      _failsafe?.cancel();
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
