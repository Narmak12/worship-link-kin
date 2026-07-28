import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/common/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.church_outlined, size: 64, color: AppColors.deepBlue),
              const SizedBox(height: 16),
              Text('Worship Link Kin', style: GoogleFonts.montserrat(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.deepBlue), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Connectons les serviteurs aux églises de Kinshasa',
                style: GoogleFonts.inter(fontSize: 15, color: AppColors.slateMuted),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
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
