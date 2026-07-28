import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/jobs_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetMinController = TextEditingController();
  final _budgetMaxController = TextEditingController();
  String? _specialite;
  String? _commune;
  DateTime? _eventDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _eventDate = picked);
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty || _specialite == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Merci de remplir le titre, la description et la spécialité.')));
      return;
    }

    await ref.read(createJobControllerProvider.notifier).createJob(
          recruiterId: user.id,
          title: _titleController.text,
          description: _descriptionController.text,
          specialite: _specialite!,
          eventDate: _eventDate,
          location: _locationController.text.isEmpty ? null : _locationController.text,
          commune: _commune,
          budgetMin: int.tryParse(_budgetMinController.text.trim()),
          budgetMax: int.tryParse(_budgetMaxController.text.trim()),
        );

    final state = ref.read(createJobControllerProvider);
    if (!mounted) return;
    if (!state.hasError) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createJobControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle annonce')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(label: 'Titre', controller: _titleController, hint: 'Ex : Chantre pour culte du dimanche'),
            const SizedBox(height: 16),
            AppTextField(label: 'Description', controller: _descriptionController, maxLines: 4, hint: 'Décris la mission, le déroulement du culte...'),
            const SizedBox(height: 16),
            Text('Spécialité recherchée', style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepBlue)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _specialite,
              hint: const Text('Choisir une spécialité'),
              items: AppConstants.talentCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _specialite = v),
            ),
            const SizedBox(height: 16),
            Text('Commune', style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepBlue)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _commune,
              hint: const Text('Choisir une commune'),
              items: AppConstants.kinshasaCommunes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _commune = v),
            ),
            const SizedBox(height: 16),
            AppTextField(label: 'Lieu précis (optionnel)', controller: _locationController, hint: 'Ex : Paroisse Saint-Michel'),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(color: AppColors.offWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.divider)),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.slateMuted),
                    const SizedBox(width: 10),
                    Text(
                      _eventDate == null ? 'Choisir la date de l\'événement' : '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}',
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateText),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: AppTextField(label: 'Budget min (CDF)', controller: _budgetMinController, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: AppTextField(label: 'Budget max (CDF)', controller: _budgetMaxController, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(label: 'Publier l\'annonce', loading: createState.isLoading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
