import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/common/app_scaffold.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Conditions d\'utilisation',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conditions d\'utilisation', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
            const SizedBox(height: 4),
            Text('Dernière mise à jour : 2026', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
            const SizedBox(height: 20),

            _Section(
              title: '1. Objet',
              body:
                  'Worship Link Kin ("l\'Application") est une plateforme numérique qui met en relation, à Kinshasa, '
                  'des talents chrétiens (musiciens, chantres, techniciens, artistes de culte, ci-après "Talents") '
                  'et des églises ou organisations chrétiennes (ci-après "Églises") recherchant des serviteurs pour '
                  'leurs cultes et événements. En créant un compte, vous acceptez les présentes conditions.',
            ),
            _Section(
              title: '2. Rôle de Worship Link Kin',
              body:
                  'Worship Link Kin agit uniquement comme intermédiaire technique de mise en relation. L\'Application '
                  'ne participe pas aux échanges de service, aux engagements pris entre un Talent et une Église, ni au '
                  'versement d\'éventuelles rémunérations, qui restent entièrement gérés entre les utilisateurs '
                  'eux-mêmes (y compris via WhatsApp une fois la mise en relation effectuée). Worship Link Kin ne '
                  'garantit ni la qualité d\'une prestation, ni le respect des engagements pris par l\'une ou l\'autre partie.',
            ),
            _Section(
              title: '3. Inscription et compte',
              body:
                  'L\'inscription se fait par numéro de téléphone, vérifié par code envoyé par SMS. Vous vous engagez '
                  'à fournir des informations exactes sur votre profil (identité, rôle, coordonnées, commune, '
                  'compétences) et à les maintenir à jour. Un compte est personnel et ne doit pas être partagé.',
            ),
            _Section(
              title: '4. Contenu publié',
              body:
                  'Vous restez propriétaire des textes, photos, audios et vidéos que vous publiez sur votre profil '
                  '(portfolio), mais vous accordez à Worship Link Kin le droit de les afficher au sein de l\'Application '
                  'dans le cadre de son fonctionnement normal. Vous vous engagez à ne publier que du contenu que vous '
                  'avez le droit de partager, et à ne publier aucun contenu illicite, diffamatoire, violent ou contraire '
                  'aux bonnes mœurs.',
            ),
            _Section(
              title: '5. Comportement attendu',
              body:
                  'Chaque utilisateur s\'engage à se comporter avec respect envers les autres membres de la plateforme, '
                  'à ne pas usurper d\'identité, à ne pas publier d\'annonces ou de candidatures frauduleuses, et à '
                  'signaler tout comportement abusif rencontré sur l\'Application.',
            ),
            _Section(
              title: '6. Suspension et résiliation',
              body:
                  'Worship Link Kin peut suspendre ou supprimer un compte en cas de non-respect des présentes '
                  'conditions, de fraude avérée, ou de signalement fondé par d\'autres utilisateurs. Vous pouvez à '
                  'tout moment demander la suppression de votre compte depuis les paramètres de l\'Application.',
            ),
            _Section(
              title: '7. Limitation de responsabilité',
              body:
                  'Worship Link Kin met tout en œuvre pour assurer la disponibilité et la fiabilité de la plateforme, '
                  'sans garantie de continuité absolue du service. L\'Application ne pourra être tenue responsable des '
                  'litiges, dommages ou pertes résultant des relations nouées entre Talents et Églises en dehors du '
                  'périmètre strict de la mise en relation.',
            ),
            _Section(
              title: '8. Droit applicable',
              body:
                  'Les présentes conditions sont régies par le droit de la République Démocratique du Congo. Tout '
                  'litige relatif à leur interprétation ou leur exécution relève de la compétence des juridictions '
                  'congolaises.',
            ),
            _Section(
              title: '9. Contact',
              body: 'Pour toute question relative aux présentes conditions, contacte-nous via l\'écran "Nous contacter" de l\'Application.',
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
