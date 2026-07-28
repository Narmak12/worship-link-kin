import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/enums.dart';
import '../../providers/auth_provider.dart';
import '../../services/supabase_client.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpVerifyScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final _codeController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length < 4) {
      setState(() => _error = 'Code invalide.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final session = await ref.read(authServiceProvider).verifyOtp(phone: widget.phone, token: code);
      if (session == null) {
        setState(() => _error = 'Vérification échouée.');
        return;
      }
      final userId = session.user.id;
      final existing = await ref.read(authServiceProvider).fetchProfile(userId);
      if (existing == null) {
        final role = ref.read(onboardingStateProvider).selectedRole ?? UserRole.talent;
        await supabase.from('profiles').insert({
          'id': userId,
          'role': role.value,
          'full_name': 'Utilisateur',
          'phone': widget.phone,
          'city': 'Kinshasa',
        });
      }
      ref.invalidate(userProfileProvider);
      if (!mounted) return;
      context.go('/onboarding/role');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Un code a été envoyé au ${widget.phone}. Saisis-le ci-dessous.',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateMuted),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Code de vérification',
              controller: _codeController,
              hint: '123456',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.sms_outlined,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.softError)),
            ],
            const SizedBox(height: 24),
            AppButton(label: 'Vérifier', loading: _loading, onPressed: _verify),
            const SizedBox(height: 12),
            AppButton(
              label: 'Renvoyer le code',
              variant: AppButtonVariant.text,
              onPressed: () => ref.read(authServiceProvider).sendOtp(widget.phone),
            ),
          ],
        ),
      ),
    );
  }
}
