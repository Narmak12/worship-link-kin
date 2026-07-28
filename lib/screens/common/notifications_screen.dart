import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  void _handleTap(BuildContext context, WidgetRef ref, Map<String, dynamic> n) {
    ref.read(notificationControllerProvider.notifier).markAsRead(n['id'] as String);
    final type = n['type'] as String?;
    switch (type) {
      case 'new_application':
        context.push('/recruiter/applications');
        break;
      case 'application_accepted':
      case 'application_rejected':
        context.push('/talent/applications');
        break;
      case 'new_invitation':
        context.push('/talent/invitations');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationControllerProvider.notifier).markAllAsRead(),
            child: const Text('Tout marquer comme lu'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(child: Text('Aucune notification pour le moment.', style: GoogleFonts.inter(color: AppColors.slateMuted)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final n = notifications[index];
              final isRead = n['is_read'] == true;
              final createdAt = DateTime.tryParse(n['created_at'] as String? ?? '');
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isRead ? Colors.white : AppColors.goldMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [AppShadows.level1],
                ),
                child: InkWell(
                  onTap: () => _handleTap(context, ref, n),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n['title'] as String? ?? '', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                      const SizedBox(height: 4),
                      Text(n['body'] as String? ?? '', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateText)),
                      if (createdAt != null) ...[
                        const SizedBox(height: 6),
                        Text(DateFormat('d MMM yyyy, HH:mm', 'fr_FR').format(createdAt), style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateMuted)),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}
