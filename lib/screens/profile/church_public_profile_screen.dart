import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../providers/public_profile_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/profile/cover_header.dart';
import '../../widgets/profile/profile_skeleton.dart';
import '../../widgets/profile/section_header.dart';

class ChurchPublicProfileScreen extends ConsumerWidget {
  final String churchId;
  const ChurchPublicProfileScreen({super.key, required this.churchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicProfileProvider(churchId));
    final jobsAsync = ref.watch(churchOpenJobsProvider(churchId));

    return Scaffold(
      appBar: AppBar(title: const Text('Profil de l\'église')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return const Center(child: Text('Profil introuvable'));
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoverHeader(
                  coverUrl: profile.coverUrl,
                  avatarUrl: profile.avatarUrl,
                  name: profile.churchName ?? profile.fullName,
                  subtitle: profile.commune ?? profile.city,
                  isVerified: profile.isVerified,
                  isAvailable: true,
                ),
                if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                  const SectionHeader(title: 'À propos'),
                  Text(profile.bio!, style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateText, height: 1.5)),
                ],
                const SectionHeader(title: 'Annonces ouvertes'),
                jobsAsync.when(
                  data: (jobs) {
                    if (jobs.isEmpty) {
                      return Text('Aucune annonce active pour le moment', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateMuted));
                    }
                    return Column(
                      children: jobs.map((job) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [AppShadows.level1]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job['title'] as String? ?? '', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                              const SizedBox(height: 4),
                              Text(job['specialite'] as String? ?? '', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: 'Contacter via WhatsApp',
                  icon: Icons.chat_outlined,
                  onPressed: () {
                    final number = (profile.whatsapp ?? profile.phone).replaceAll(RegExp(r'[^0-9]'), '');
                    launchUrl(Uri.parse('https://wa.me/$number'));
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const ProfileSkeleton(),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}
