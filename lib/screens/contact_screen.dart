import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../widgets/common/app_scaffold.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Contact',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Besoin d\'aide ?', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: AppColors.deepBlue),
              title: const Text('Email'),
              subtitle: const Text('support@worshiplink.kin'),
              onTap: () => launchUrl(Uri.parse('mailto:support@worshiplink.kin')),
            ),
            ListTile(
              leading: const Icon(Icons.phone_outlined, color: AppColors.deepBlue),
              title: const Text('WhatsApp'),
              subtitle: const Text('+243 999 999 999'),
              onTap: () => launchUrl(Uri.parse('https://wa.me/243999999999')),
            ),
          ],
        ),
      ),
    );
  }
}
