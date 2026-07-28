import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/supabase_config.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_edit_provider.dart';
import '../../services/upload_service.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/profile/section_header.dart';

class ChurchEditProfileScreen extends ConsumerStatefulWidget {
  const ChurchEditProfileScreen({super.key});

  @override
  ConsumerState<ChurchEditProfileScreen> createState() => _ChurchEditProfileScreenState();
}

class _ChurchEditProfileScreenState extends ConsumerState<ChurchEditProfileScreen> {
  late TextEditingController _bioController;
  bool _initialized = false;
  bool _uploadingAvatar = false;

  @override
  void dispose() {
    if (_initialized) _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadAvatar() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => _uploadingAvatar = true);
    final url = await UploadService().uploadImage(
      file: File(picked.path),
      userId: user.id,
      bucket: SupabaseConfig.avatarsBucket,
      onProgress: (_) {},
    );
    if (url != null) {
      await ref.read(profileEditControllerProvider.notifier).saveProfile(userId: user.id, data: {'avatar_url': url});
      ref.invalidate(userProfileProvider);
    }
    if (mounted) setState(() => _uploadingAvatar = false);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final user = ref.watch(currentUserProvider);

    return AppScaffold(
      title: 'Profil de l\'église',
      showNotificationBell: false,
      body: profileAsync.when(
        data: (profile) {
          if (profile == null || user == null) return const Center(child: Text('Profil introuvable'));
          if (!_initialized) {
            _bioController = TextEditingController(text: profile.bio ?? '');
            _initialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _uploadingAvatar ? null : _pickAndUploadAvatar,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                          child: profile.avatarUrl == null ? const Icon(Icons.church_outlined, size: 40) : null,
                        ),
                        if (_uploadingAvatar) const CircularProgressIndicator(),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: AppColors.deepBlue, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(child: Text(profile.churchName ?? profile.fullName, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepBlue))),

                const SectionHeader(title: 'Présentation'),
                AppTextField(
                  label: 'Bio de l\'église',
                  controller: _bioController,
                  maxLines: 4,
                  onChanged: (v) => ref.read(profileEditControllerProvider.notifier).debouncedSave(userId: user.id, data: {'bio': v}),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}
