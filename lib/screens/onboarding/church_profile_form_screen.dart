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

class ChurchProfileFormScreen extends ConsumerStatefulWidget {
  const ChurchProfileFormScreen({super.key});

  @override
  ConsumerState<ChurchProfileFormScreen> createState() => _ChurchProfileFormScreenState();
}

class _ChurchProfileFormScreenState extends ConsumerState<ChurchProfileFormScreen> {
  final _churchNameController = TextEditingController();
  final _pastorNameController = TextEditingController();
  final _bioController = TextEditingController();
  String? _commune;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _churchNameController.dispose();
    _pastorNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_churchNameController.text.trim().isEmpty || _pastorNameController.text.trim().isEmpty || _commune == null) {
      setState(() => _error = 'Merci de remplir le nom de l\'église, le responsable et la commune.');
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
        'full_name': _pastorNameController.text.trim(),
        'church_name': _churchNameController.text.trim(),
        'commune': _commune,
        'bio': _bioController.text.trim(),
        'role': 'recruiter',
        'is_active': true,
      }).eq('id', user.id);
      ref.invalidate(userProfileProvider);
      if (!mounted) return;
      context.go('/home/recruiter');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil de ton église')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(label: 'Nom de l\'église', controller: _churchNameController, hint: 'Ex : Église du Réveil', prefixIcon: Icons.church_outlined),
            const SizedBox(height: 20),
            AppTextField(label: 'Nom du responsable', controller: _pastorNameController, hint: 'Ex : Pasteur David Kabila', prefixIcon: Icons.person_outline),
            const SizedBox(height: 20),
            Text('Commune', style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepBlue)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _commune,
              hint: const Text('Choisis la commune'),
              items: AppConstants.kinshasaCommunes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _commune = v),
            ),
            const SizedBox(height: 20),
            AppTextField(label: 'Présentation (optionnel)', controller: _bioController, hint: 'Décris ton église en quelques mots', maxLines: 4),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.softError)),
            ],
            const SizedBox(height: 24),
            AppButton(label: 'Terminer le profil', loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
