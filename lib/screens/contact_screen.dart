import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../widgets/common/app_scaffold.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const String _phoneDisplay = '+243 972 494 081';
  static const String _phoneDial = '+243972494081';
  static const String _whatsappNumber = '243972494081';
  static const String _email = 'maknar462@gmail.com';

  Future<void> _call() => launchUrl(Uri.parse('tel:$_phoneDial'));
  Future<void> _whatsapp() => launchUrl(Uri.parse('https://wa.me/$_whatsappNumber'), mode: LaunchMode.externalApplication);
  Future<void> _emailUs() => launchUrl(Uri.parse('mailto:$_email?subject=${Uri.encodeComponent("Contact Worship Link Kin")}'));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Nous contacter',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Une question ?', style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.deepBlue)),
            const SizedBox(height: 6),
            Text(
              "Notre équipe te répond directement par téléphone, WhatsApp ou e-mail.",
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateMuted, height: 1.4),
            ),
            const SizedBox(height: 28),

            _ContactCard(
              icon: Icons.call_outlined,
              iconColor: AppColors.deepBlue,
              title: 'Appeler',
              subtitle: _phoneDisplay,
              actionLabel: 'Appeler',
              onTap: _call,
            ),
            const SizedBox(height: 14),
            _ContactCard(
              icon: Icons.chat_outlined,
              iconColor: const Color(0xFF25D366),
              title: 'WhatsApp',
              subtitle: _phoneDisplay,
              actionLabel: 'Ouvrir WhatsApp',
              onTap: _whatsapp,
            ),
            const SizedBox(height: 14),
            _ContactCard(
              icon: Icons.mail_outline,
              iconColor: AppColors.gold,
              title: 'E-mail',
              subtitle: _email,
              actionLabel: 'Envoyer un e-mail',
              onTap: _emailUs,
            ),

            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.offWhite, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: AppColors.slateMuted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nous répondons généralement dans la journée, du lundi au samedi.',
                      style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.slateMuted, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [AppShadows.level1],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateMuted)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}
