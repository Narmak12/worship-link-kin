import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/job_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/matching_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

Future<void> showApplyBottomSheet(BuildContext context, JobModel job) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ApplyBottomSheet(job: job),
  );
}

class ApplyBottomSheet extends ConsumerStatefulWidget {
  final JobModel job;
  const ApplyBottomSheet({super.key, required this.job});

  @override
  ConsumerState<ApplyBottomSheet> createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends ConsumerState<ApplyBottomSheet> {
  final _messageController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final price = int.tryParse(_priceController.text.trim());
    await ref.read(applicationControllerProvider.notifier).apply(
          jobId: widget.job.id,
          talentId: user.id,
          message: _messageController.text,
          proposedPrice: price,
        );
    final state = ref.read(applicationControllerProvider);
    if (!mounted) return;
    if (!state.hasError) {
      ref.invalidate(hasAppliedProvider(widget.job.id));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Candidature envoyée !')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final applyState = ref.watch(applicationControllerProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text('Postuler à "${widget.job.title}"', style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
            const SizedBox(height: 16),
            AppTextField(label: 'Message (optionnel)', controller: _messageController, hint: 'Présente-toi en quelques mots', maxLines: 3),
            const SizedBox(height: 16),
            AppTextField(label: 'Tarif proposé en CDF (optionnel)', controller: _priceController, keyboardType: TextInputType.number, hint: 'Ex : 50000'),
            if (applyState.hasError) ...[
              const SizedBox(height: 12),
              Text(applyState.error.toString(), style: GoogleFonts.inter(fontSize: 13, color: AppColors.softError)),
            ],
            const SizedBox(height: 20),
            AppButton(label: 'Envoyer ma candidature', loading: applyState.isLoading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
