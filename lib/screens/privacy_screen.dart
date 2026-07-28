import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/common/app_scaffold.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Politique de confidentialité',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Politique de confidentialité', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
            const SizedBox(height: 4),
            Text('Dernière mise à jour : 2026', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
            const SizedBox(height: 20),

            _Section(
              title: '1. Données collectées',
              body:
                  'Nous collectons les informations que tu nous fournis directement : numéro de téléphone (et code de '
                  'vérification associé), nom complet, ville/commune, rôle (Talent ou Église), nom d\'église et de '
                  'responsable le cas échéant, bio, tarifs indicatifs, compétences, ainsi que les photos, audios ou '
                  'vidéos que tu choisis de publier sur ton profil (portfolio). Nous collectons également les '
                  'candidatures, invitations et messages échangés au sein de l\'Application.',
            ),
            _Section(
              title: '2. Utilisation des données',
              body:
                  'Ces informations servent uniquement à faire fonctionner la mise en relation entre Talents et '
                  'Églises : affichage des profils et annonces, gestion des candidatures et invitations, envoi de '
                  'notifications push (nouvelle candidature, réponse à une candidature, nouvelle invitation), et '
                  'amélioration du service. Nous ne vendons ni ne partageons tes données personnelles à des fins '
                  'publicitaires.',
            ),
            _Section(
              title: '3. Sous-traitants techniques',
              body:
                  'L\'Application s\'appuie sur des prestataires techniques pour fonctionner : Supabase (base de '
                  'données, authentification, stockage des fichiers) et Firebase / Google (notifications push). Ces '
                  'prestataires traitent les données uniquement pour le compte de Worship Link Kin, dans le cadre '
                  'strict de la fourniture du service.',
            ),
            _Section(
              title: '4. Conservation des données',
              body:
                  'Tes données sont conservées tant que ton compte est actif. Si tu demandes la suppression de ton '
                  'compte, tes informations de profil sont anonymisées ou supprimées, à l\'exception des données '
                  'dont la conservation serait nécessaire pour des raisons légales ou pour la résolution d\'un litige '
                  'en cours.',
            ),
            _Section(
              title: '5. Tes droits',
              body:
                  'Tu peux à tout moment consulter, corriger ou supprimer les informations de ton profil directement '
                  'depuis l\'Application (écran "Paramètres"). Tu peux également nous contacter pour toute demande '
                  'relative à tes données personnelles via l\'écran "Nous contacter".',
            ),
            _Section(
              title: '6. Sécurité',
              body:
                  'L\'accès à ton compte est protégé par vérification du numéro de téléphone via un code à usage '
                  'unique. Les données sont stockées et transmises via des connexions chiffrées. Aucune méthode n\'est '
                  'infaillible à 100 %, mais nous mettons en œuvre des mesures raisonnables pour protéger tes '
                  'informations.',
            ),
            _Section(
              title: '7. Contact',
              body:
                  'Pour toute question relative à cette politique de confidentialité ou à tes données personnelles, '
                  'contacte-nous via l\'écran "Nous contacter" de l\'Application.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
          const SizedBox(height: 6),
          Text(body, style: GoogleFonts.inter(fontSize: 13, height: 1.6, color: AppColors.slateText)),
        ],
      ),
    );
  }
}
