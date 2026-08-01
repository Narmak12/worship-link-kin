import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/application_model.dart';
import '../../providers/matching_provider.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/talent_bottom_nav.dart';
import '../../widgets/common/empty_state.dart';

class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(talentApplicationsProvider);

    return AppScaffold(
      title: 'Mes candidatures',
      bottomNavigationBar: const TalentBottomNav(currentIndex: 2),
      body: appsAsync.when(
        data: (apps) {
          if (apps.isEmpty) {
            return const EmptyState(
              icon: Icons.assignment_outlined,
              title: 'Aucune candidature',
              subtitle: 'Postule à une annonce depuis l\'accueil pour la voir apparaître ici.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: apps.length,
            itemBuilder: (context, index) => _ApplicationTile(app: apps[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: e.toString()),
      ),
    );
  }
}

class _ApplicationTile extends StatelessWidget {
  final ApplicationModel app;
  const _ApplicationTile({required this.app});

  Color _statusColor() {
    if (app.isAccepted) return AppColors.success;
    if (app.isRejected) return AppColors.softError;
    return AppColors.gold;
  }

  String _statusLabel() {
    if (app.isAccepted) return 'Acceptée';
    if (app.isRejected) return 'Non retenue';
    return 'En attente';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [AppShadows.level1]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.jobTitle ?? 'Mission', style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                const SizedBox(height: 4),
                if (app.jobSpecialite != null)
                  Text(app.jobSpecialite!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: _statusColor().withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
            child: Text(_statusLabel(), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor())),
          ),
        ],
      ),
    );
  }
}
