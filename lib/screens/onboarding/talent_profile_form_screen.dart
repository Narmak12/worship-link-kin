import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/supabase_client.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class TalentProfileFormScreen extends ConsumerStatefulWidget {
  const TalentProfileFormScreen({super.key});

  @override
  ConsumerState<TalentProfileFormScreen> createState() => _TalentProfileFormScreenState();
}

class _TalentProfileFormScreenState extends ConsumerState<TalentProfileFormScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  String? _commune;
  String? _category;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty || _commune == null || _category == null) {
      setState(() => _error = 'Merci de remplir au moins ton nom, ta commune et ta spécialité.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('Utilisateur non connecté');
      await supabase.from('profiles').update({
        'full_name': _nameController.text.trim(),
        'commune': _commune,
        'bio': _bioController.text.trim().isEmpty ? _category : '${_bioController.text.trim()} — $_category',
        'role': 'talent',
        'is_active': true,
      }).eq('id', user.id);
      ref.invalidate(userProfileProvider);
      if (!mounted) return;
      context.go('/home/talent');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ton profil de talent')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(label: 'Nom complet', controller: _nameController, hint: 'Ex : Jean Mukendi', prefixIcon: Icons.person_outline),
            const SizedBox(height: 20),
            Text('Commune', style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepBlue)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _commune,
              hint: const Text('Choisis ta commune'),
              items: AppConstants.kinshasaCommunes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _commune = v),
            ),
            const SizedBox(height: 20),
            Text('Spécialité principale', style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepBlue)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _category,
              hint: const Text('Choisis ta spécialité'),
              items: AppConstants.talentCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v),
            ),
            const SizedBox(height: 20),
            AppTextField(label: 'Bio (optionnel)', controller: _bioController, hint: 'Parle un peu de toi et de ton expérience', maxLines: 4),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.softError)),
            ],
            const SizedBox(height: 24),
            AppButton(label: 'Terminer mon profil', loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
