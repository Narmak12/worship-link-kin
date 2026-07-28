import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_provider.dart';

final favoritesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return await supabase.from('favorites').select('*, talent:profiles!favorites_talent_id_fkey(*)').eq('recruiter_id', user.id);
});

final isFavoriteProvider = FutureProvider.family<bool, String>((ref, talentId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  final res = await supabase.from('favorites').select('id').eq('recruiter_id', user.id).eq('talent_id', talentId).maybeSingle();
  return res != null;
});

final favoriteControllerProvider = StateNotifierProvider<FavoriteController, AsyncValue<void>>((ref) => FavoriteController());

class FavoriteController extends StateNotifier<AsyncValue<void>> {
  FavoriteController() : super(const AsyncValue.data(null));
  Future<void> toggle(String recruiterId, String talentId) async {
    try {
      final existing = await supabase.from('favorites').select('id').eq('recruiter_id', recruiterId).eq('talent_id', talentId).maybeSingle();
      if (existing != null) await supabase.from('favorites').delete().eq('id', existing['id']);
      else await supabase.from('favorites').insert({'recruiter_id': recruiterId, 'talent_id': talentId});
    } catch (e) { debugPrint('Favorite toggle error: $e'); }
  }
}
