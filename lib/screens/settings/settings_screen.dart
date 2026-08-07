import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/enums.dart';
import '../../providers/auth_provider.dart';
import '../../services/notification_service.dart';
import '../../widgets/common/app_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final role = profileAsync.valueOrNull?.role;

    return AppScaffold(
      title: 'Paramètres',
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Profil rapide
          profileAsync.when(
            data: (profile) => ListTile(
              leading: CircleAvatar(
                backgroundImage: profile?.avatarUrl != null ? NetworkImage(profile!.avatarUrl!) : null,
                child: profile?.avatarUrl == null ? const Icon(Icons.person) : null,
              ),
              title: Text(profile?.fullName ?? 'Utilisateur', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              subtitle: Text(profile?.role == UserRole.talent ? 'Talent' : 'Église'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                profile?.role == UserRole.talent ? '/talent/edit-profile' : '/recruiter/edit-profile',
              ),
            ),
            loading: () => const ListTile(leading: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(),

          if (role == UserRole.talent) ...[
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined, color: AppColors.deepBlue),
              title: const Text('Mon calendrier'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/calendar'),
            ),
            ListTile(
              leading: const Icon(Icons.mail_outline, color: AppColors.deepBlue),
              title: const Text('Mes invitations'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/talent/invitations'),
            ),
          ],
          if (role == UserRole.recruiter)
            ListTile(
              leading: const Icon(Icons.favorite_outline, color: AppColors.deepBlue),
              title: const Text('Mes favoris'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/favorites'),
            ),

          ListTile(
            leading: const Icon(Icons.notifications_outlined, color: AppColors.deepBlue),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/notifications'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.deepBlue),
            title: const Text('À propos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/about'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppColors.deepBlue),
            title: const Text('Conditions d\'utilisation'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/terms'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.deepBlue),
            title: const Text('Politique de confidentialité'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/privacy'),
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline, color: AppColors.deepBlue),
            title: const Text('Nous contacter'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/contact'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.softError),
            title: Text('Déconnexion', style: GoogleFonts.inter(color: AppColors.softError, fontWeight: FontWeight.w600)),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Se déconnecter ?'),
                  content: const Text('Tu devras te reconnecter pour accéder à nouveau à ton compte.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
                    TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Déconnexion')),
                  ],
                ),
              );
              if (confirmed != true) return;
              // La déconnexion réelle passe en premier — le nettoyage du jeton
              // de notifications (Firebase) est fait "au mieux", sans bloquer,
              // car Firebase n'est pas encore pleinement configuré.
              try {
                await ref.read(authServiceProvider).signOut();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de déconnexion : $e')));
                }
                return;
              }
              unawaited(ref.read(notificationServiceProvider).logout().timeout(const Duration(seconds: 3), onTimeout: () {}));
              ref.invalidate(userProfileProvider);
              if (context.mounted) context.go('/welcome');
            },
          ),
        ],
      ),
    );
  }
}
