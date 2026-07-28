import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/enums.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  final String role;
  const PhoneInputScreen({super.key, required this.role});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _phoneController = TextEditingController(text: '+243');
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 9) {
      setState(() => _error = 'Numéro de téléphone invalide.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Mémorise le rôle choisi et le téléphone pour la suite de l'onboarding.
      final role = widget.role == 'recruiter' ? UserRole.recruiter : UserRole.talent;
      ref.read(onboardingStateProvider.notifier).state =
          ref.read(onboardingStateProvider).copyWith(phone: phone, selectedRole: role);
      await ref.read(authServiceProvider).sendOtp(phone);
      if (!mounted) return;
      context.push('/auth/otp', extra: phone);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Numéro de téléphone')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entre ton numéro de téléphone pour recevoir un code de vérification par SMS.',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateMuted),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Téléphone',
              controller: _phoneController,
              hint: '+243 999 999 999',
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.softError)),
            ],
            const SizedBox(height: 24),
            AppButton(label: 'Recevoir le code', loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
