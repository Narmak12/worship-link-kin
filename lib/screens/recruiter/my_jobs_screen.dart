import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/public_profile_provider.dart';
import '../../services/supabase_client.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/recruiter_bottom_nav.dart';

class MyJobsScreen extends ConsumerWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final jobsAsync = user != null ? ref.watch(churchOpenJobsProvider(user.id)) : const AsyncValue.data(<Map<String, dynamic>>[]);

    return AppScaffold(
      title: 'Mes annonces',
      bottomNavigationBar: const RecruiterBottomNav(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepBlue,
        onPressed: () => context.push('/recruiter/create-job'),
        child: const Icon(Icons.add),
      ),
      body: jobsAsync.when(
        data: (jobs) {
          if (jobs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Tu n\'as pas encore publié d\'annonce. Appuie sur + pour commencer.', textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.slateMuted)),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) => _JobRow(job: jobs[index], ref: ref),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

class _JobRow extends StatelessWidget {
  final Map<String, dynamic> job;
  final WidgetRef ref;
  const _JobRow({required this.job, required this.ref});

  Future<void> _close(BuildContext context) async {
    await supabase.from('jobs').update({'status': 'closed'}).eq('id', job['id']);
    ref.invalidate(churchOpenJobsProvider);
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
                Text(job['title'] as String? ?? '', style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
                const SizedBox(height: 4),
                Text(job['specialite'] as String? ?? '', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateMuted)),
              ],
            ),
          ),
          TextButton(onPressed: () => _close(context), child: const Text('Clôturer')),
        ],
      ),
    );
  }
}
