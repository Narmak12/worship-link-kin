import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/invitation_model.dart';
import '../../providers/matching_provider.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/empty_state.dart';

class MyInvitationsScreen extends ConsumerWidget {
  const MyInvitationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationsAsync = ref.watch(talentInvitationsProvider);

    return AppScaffold(
      title: 'Mes invitations',
      body: invitationsAsync.when(
        data: (invitations) {
          if (invitations.isEmpty) {
            return const EmptyState(
              icon: Icons.mail_outline,
              title: 'Aucune invitation',
              subtitle: 'Les invitations reçues d\'une église apparaîtront ici.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: invitations.length,
            itemBuilder: (context, index) => _InvitationTile(invitation: invitations[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: e.toString()),
      ),
    );
  }
}

class _InvitationTile extends ConsumerWidget {
  final InvitationModel invitation;
  const _InvitationTile({required this.invitation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recruiter = invitation.recruiterProfile;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [AppShadows.level1]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: recruiter?.avatarUrl != null ? NetworkImage(recruiter!.avatarUrl!) : null,
                child: recruiter?.avatarUrl == null ? const Icon(Icons.church_outlined, size: 18) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(recruiter?.churchName ?? recruiter?.fullName ?? 'Église', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
              ),
            ],
          ),
          if (invitation.message != null) ...[
            const SizedBox(height: 8),
            Text(invitation.message!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateText)),
          ],
          if (invitation.isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ref.read(invitationControllerProvider.notifier).respond(invitationId: invitation.id, accept: false),
                    child: const Text('Refuser'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ref.read(invitationControllerProvider.notifier).respond(invitationId: invitation.id, accept: true),
                    child: const Text('Accepter'),
                  ),
                ),
              ],
            ),
          ] else
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: (invitation.isAccepted ? AppColors.success : AppColors.slateMuted).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                invitation.isAccepted ? 'Acceptée' : 'Refusée',
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: invitation.isAccepted ? AppColors.success : AppColors.slateMuted),
              ),
            ),
        ],
      ),
    );
  }
}
