import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/common/app_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'À propos',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.church_outlined, size: 64, color: AppColors.deepBlue),
            const SizedBox(height: 16),
            Text('Worship Link Kin', style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
            const SizedBox(height: 8),
            Text('Version 1.0.0', style: GoogleFonts.inter(color: AppColors.slateMuted)),
            const SizedBox(height: 24),
            Text(
              'Worship Link Kin connecte les talents du ministère chrétien avec les églises de Kinshasa. Notre mission est de faciliter le service dans le culte en mettant en relation les serviteurs et les églises qui en ont besoin.',
              style: GoogleFonts.inter(fontSize: 15, height: 1.6, color: AppColors.slateText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
