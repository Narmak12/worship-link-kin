import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/empty_state.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return AppScaffold(
      title: 'Mes favoris',
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_outline,
              title: 'Aucun favori',
              subtitle: 'Ajoute des talents en favoris depuis leur profil pour les retrouver ici.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final talent = favorites[index]['talent'] as Map<String, dynamic>?;
              if (talent == null) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [AppShadows.level1]),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: talent['avatar_url'] != null ? NetworkImage(talent['avatar_url'] as String) : null,
                    child: talent['avatar_url'] == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(talent['full_name'] as String? ?? '', style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                  subtitle: Text(talent['commune'] as String? ?? '', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/talent/${talent['id']}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: e.toString()),
      ),
    );
  }
}
