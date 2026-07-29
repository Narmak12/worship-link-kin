import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_client.dart';
import '../config/supabase_config.dart';
import '../models/profile_model.dart';

final publicProfileProvider = FutureProvider.family<ProfileModel?, String>((ref, userId) async {
  try {
    final data = await supabase.from(SupabaseConfig.profilesTable).select().eq('id', userId).maybeSingle();
    return data == null ? null : ProfileModel.fromJson(data);
  } catch (e) { debugPrint('publicProfile error: $e'); return null; }
});

final profileMediaProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  try { return await supabase.from(SupabaseConfig.mediaTable).select().eq('profile_id', userId).order('display_order', ascending: true); } catch (e) { return []; }
});

final profileReviewsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  try { return await supabase.from('reviews').select('*, reviewer:profiles!reviews_reviewer_id_fkey(full_name, avatar_url)').eq('reviewee_id', userId).order('created_at', ascending: false); } catch (e) { return []; }
});

final profileStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  try {
    final missionsResponse = await supabase.from('applications').select('id').eq('talent_id', userId).eq('status', 'accepted').count(CountOption.exact);
    final totalResponse = await supabase.from('applications').select('id').eq('talent_id', userId).count(CountOption.exact);
    final missions = missionsResponse.count;
    final total = totalResponse.count;
    final taux = total > 0 ? ((missions / total) * 100).round() : 0;
    return {'missions': missions, 'taux_acceptation': taux, 'total_candidatures': total};
  } catch (e) { return {'missions': 0, 'taux_acceptation': 0, 'total_candidatures': 0}; }
});

final churchOpenJobsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  try { return await supabase.from(SupabaseConfig.jobsTable).select().eq('recruiter_id', userId).eq('status', 'open').order('created_at', ascending: false); } catch (e) { return []; }
});
