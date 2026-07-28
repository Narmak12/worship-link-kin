import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/public_profile_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/profile/cover_header.dart';
import '../../widgets/profile/media_grid.dart';
import '../../widgets/profile/profile_skeleton.dart';
import '../../widgets/profile/review_card.dart';
import '../../widgets/profile/section_header.dart';
import '../../widgets/profile/skill_chips.dart';
import '../../widgets/profile/stat_badge.dart';

class TalentPublicProfileScreen extends ConsumerWidget {
  final String talentId;
  const TalentPublicProfileScreen({super.key, required this.talentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicProfileProvider(talentId));
    final mediaAsync = ref.watch(profileMediaProvider(talentId));
    final reviewsAsync = ref.watch(profileReviewsProvider(talentId));
    final statsAsync = ref.watch(profileStatsProvider(talentId));
    final currentUser = ref.watch(currentUserProvider);
    final isFavoriteAsync = ref.watch(isFavoriteProvider(talentId));

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
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
                  name: profile.fullName,
                  subtitle: profile.commune ?? profile.city,
                  isVerified: profile.isVerified,
                  isAvailable: profile.isAvailable,
                ),
                const SizedBox(height: 20),
                statsAsync.when(
                  data: (stats) => Row(
                    children: [
                      Expanded(child: StatBadge(icon: Icons.check_circle_outline, label: 'Missions', value: '${stats['missions'] ?? 0}')),
                      const SizedBox(width: 10),
                      Expanded(child: StatBadge(icon: Icons.trending_up, label: 'Taux d\'acceptation', value: '${stats['taux_acceptation'] ?? 0}%')),
                    ],
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                  const SectionHeader(title: 'À propos'),
                  Text(profile.bio!, style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateText, height: 1.5)),
                ],
                const SectionHeader(title: 'Portfolio'),
                mediaAsync.when(
                  data: (media) => MediaGrid(media: media),
                  loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SectionHeader(title: 'Avis'),
                reviewsAsync.when(
                  data: (reviews) {
                    if (reviews.isEmpty) {
                      return Text('Aucun avis pour le moment', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateMuted));
                    }
                    return Column(
                      children: reviews.map((r) {
                        final reviewer = r['reviewer'] as Map<String, dynamic>?;
                        return ReviewCard(
                          reviewerName: reviewer?['full_name'] as String? ?? 'Église',
                          avatarUrl: reviewer?['avatar_url'] as String?,
                          rating: (r['rating'] as int?) ?? 5,
                          comment: r['comment'] as String? ?? '',
                          date: DateTime.tryParse(r['created_at'] as String? ?? '') ?? DateTime.now(),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                if (currentUser != null && currentUser.id != talentId) ...[
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Contacter via WhatsApp',
                          icon: Icons.chat_outlined,
                          onPressed: () {
                            final number = (profile.whatsapp ?? profile.phone).replaceAll(RegExp(r'[^0-9]'), '');
                            launchUrl(Uri.parse('https://wa.me/$number'));
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      isFavoriteAsync.when(
                        data: (isFav) => IconButton(
                          icon: Icon(isFav ? Icons.favorite : Icons.favorite_outline, color: AppColors.softError),
                          onPressed: () async {
                            await ref.read(favoriteControllerProvider.notifier).toggle(currentUser.id, talentId);
                            ref.invalidate(isFavoriteProvider(talentId));
                            ref.invalidate(favoritesProvider);
                          },
                        ),
                        loading: () => const SizedBox(width: 40),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
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
