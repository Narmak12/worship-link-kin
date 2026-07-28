import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../models/job_model.dart';
import '../../providers/jobs_provider.dart';
import 'apply_bottom_sheet.dart';
import '../../providers/matching_provider.dart';

class JobsFeedScreen extends ConsumerWidget {
  const JobsFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsStreamProvider);
    final filter = ref.watch(jobFilterProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(label: 'Toutes', selected: filter == null, onTap: () => ref.read(jobFilterProvider.notifier).state = null),
                const SizedBox(width: 8),
                ...AppConstants.talentCategories.map((c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(label: c, selected: filter == c, onTap: () => ref.read(jobFilterProvider.notifier).state = c),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          child: jobsAsync.when(
            data: (jobs) {
              if (jobs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      '« Car là où deux ou trois sont assemblés en mon nom, je suis au milieu d\'eux. » — Matthieu 18:20\n\nAucune annonce disponible pour le moment.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateMuted, height: 1.5),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: jobs.length,
                itemBuilder: (context, index) => _JobCard(job: jobs[index]),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur : $e', style: GoogleFonts.inter(color: AppColors.softError))),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.deepBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.deepBlue : AppColors.divider),
        ),
        alignment: Alignment.center,
        child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.slateText)),
      ),
    );
  }
}

class _JobCard extends ConsumerWidget {
  final JobModel job;
  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasApplied = ref.watch(hasAppliedProvider(job.id)).valueOrNull ?? false;

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
                backgroundImage: job.recruiterAvatarUrl != null ? NetworkImage(job.recruiterAvatarUrl!) : null,
                child: job.recruiterAvatarUrl == null ? const Icon(Icons.church_outlined, size: 18) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(job.displayChurchName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slateText)),
              ),
              if (job.commune != null)
                Text(job.commune!, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Text(job.title, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
          const SizedBox(height: 6),
          Text(job.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateText)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _MetaChip(icon: Icons.event_outlined, label: job.formattedEventDate),
              _MetaChip(icon: Icons.payments_outlined, label: job.budgetDisplay),
              if (job.specialite != null) _MetaChip(icon: Icons.category_outlined, label: job.specialite!),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: hasApplied ? null : () => showApplyBottomSheet(context, job),
              child: Text(hasApplied ? 'Déjà postulé' : 'Postuler'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: AppColors.offWhite, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.slateMuted),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateMuted)),
        ],
      ),
    );
  }
}
