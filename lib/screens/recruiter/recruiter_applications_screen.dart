import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/application_model.dart';
import '../../providers/matching_provider.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/recruiter_bottom_nav.dart';

class RecruiterApplicationsScreen extends ConsumerWidget {
  const RecruiterApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(recruiterApplicationsProvider);

    return AppScaffold(
      title: 'Candidatures reçues',
      bottomNavigationBar: const RecruiterBottomNav(currentIndex: 2),
      body: appsAsync.when(
        data: (apps) {
          if (apps.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Aucune candidature reçue pour le moment.', style: GoogleFonts.inter(color: AppColors.slateMuted)),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: apps.length,
            itemBuilder: (context, index) => _ApplicationCard(app: apps[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

class _ApplicationCard extends ConsumerWidget {
  final ApplicationModel app;
  const _ApplicationCard({required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talent = app.talentProfile;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [AppShadows.level1]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: talent != null ? () => context.push('/talent/${talent.id}') : null,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: talent?.avatarUrl != null ? NetworkImage(talent!.avatarUrl!) : null,
                  child: talent?.avatarUrl == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(talent?.fullName ?? 'Talent', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                      Text('Pour : ${app.jobTitle ?? "Mission"}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (app.message != null && app.message!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(app.message!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateText)),
          ],
          const SizedBox(height: 12),
          if (app.isPending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ref.read(applicationControllerProvider.notifier).updateStatus(applicationId: app.id, newStatus: 'rejected'),
                    child: const Text('Refuser'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ref.read(applicationControllerProvider.notifier).updateStatus(applicationId: app.id, newStatus: 'accepted'),
                    child: const Text('Accepter'),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: (app.isAccepted ? AppColors.success : AppColors.softError).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    app.isAccepted ? 'Acceptée' : 'Refusée',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: app.isAccepted ? AppColors.success : AppColors.softError),
                  ),
                ),
                const Spacer(),
                if (app.isAccepted && talent != null && (talent.whatsapp != null || talent.phone.isNotEmpty))
                  TextButton.icon(
                    icon: const Icon(Icons.chat_outlined, size: 16),
                    label: const Text('WhatsApp'),
                    onPressed: () {
                      final number = (talent.whatsapp ?? talent.phone).replaceAll(RegExp(r'[^0-9]'), '');
                      launchUrl(Uri.parse('https://wa.me/$number'));
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
