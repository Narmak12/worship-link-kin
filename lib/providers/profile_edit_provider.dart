import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'auth_provider.dart';

final allSkillsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await supabase.from('skills').select().order('display_order', ascending: true);
});

final userSkillsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return await supabase.from('profile_skills').select('*, skill:skills(*)').eq('profile_id', user.id);
});

final userMediaProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return await supabase.from('media').select().eq('profile_id', user.id).order('display_order', ascending: true);
});

final profileEditControllerProvider = StateNotifierProvider<ProfileEditController, AsyncValue<void>>((ref) => ProfileEditController());

class ProfileEditController extends StateNotifier<AsyncValue<void>> {
  ProfileEditController() : super(const AsyncValue.data(null));
  Timer? _debounceTimer;
  void debouncedSave({required String userId, required Map<String, dynamic> data}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () async => await saveProfile(userId: userId, data: data));
  }
  Future<void> saveProfile({required String userId, required Map<String, dynamic> data}) async {
    state = const AsyncValue.loading();
    try { await supabase.from('profiles').update(data).eq('id', userId); state = const AsyncValue.data(null); }
    on PostgrestException catch (e, st) { state = AsyncValue.error(e.message, st); }
    catch (e, st) { state = AsyncValue.error(e.toString(), st); }
  }
  Future<void> toggleAvailability(String userId, bool available) async => await saveProfile(userId: userId, data: {'is_available': available});
  Future<void> addSkill(String userId, int skillId, String level) async {
    try { await supabase.from('profile_skills').upsert({'profile_id': userId, 'skill_id': skillId, 'level': level}); } catch (e) { debugPrint('addSkill error: $e'); }
  }
  Future<void> removeSkill(String userId, int skillId) async {
    try { await supabase.from('profile_skills').delete().eq('profile_id', userId).eq('skill_id', skillId); } catch (e) { debugPrint('removeSkill error: $e'); }
  }
  Future<void> saveMediaRecord({required String userId, required String type, required String storagePath, required String publicUrl, required String bucket}) async {
    try { await supabase.from('media').insert({'profile_id': userId, 'type': type, 'storage_path': storagePath, 'public_url': publicUrl}); } catch (e) { debugPrint('saveMedia error: $e'); }
  }
  @override void dispose() { _debounceTimer?.cancel(); super.dispose(); }
}
