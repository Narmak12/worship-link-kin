import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/job_model.dart';

final jobFilterProvider = StateProvider<String?>((ref) => null);

final jobsStreamProvider = StreamProvider<List<JobModel>>((ref) {
  final filter = ref.watch(jobFilterProvider);
  var query = supabase.from(SupabaseConfig.jobsTable).select('''*, profiles:recruiter_id (church_name, full_name, whatsapp, phone, avatar_url)''').eq('status', 'open').order('created_at', ascending: false);
  if (filter != null && filter.isNotEmpty) query = query.ilike('specialite', '%$filter%');
  return query.asStream().map((data) => (data as List<dynamic>).map((j) => JobModel.fromJson(j as Map<String, dynamic>)).toList());
});

final createJobControllerProvider = StateNotifierProvider<CreateJobController, AsyncValue<void>>((ref) => CreateJobController());

class CreateJobController extends StateNotifier<AsyncValue<void>> {
  CreateJobController() : super(const AsyncValue.data(null));
  Future<void> createJob({required String recruiterId, required String title, required String description, required String specialite, required DateTime? eventDate, required String? location, required String? commune, required int? budgetMin, required int? budgetMax}) async {
    state = const AsyncValue.loading();
    try {
      await supabase.from(SupabaseConfig.jobsTable).insert({
        'recruiter_id': recruiterId, 'title': title.trim(), 'description': description.trim(),
        'specialite': specialite.trim(), 'event_date': eventDate?.toIso8601String(),
        'location': location?.trim(), 'commune': commune, 'budget_min': budgetMin, 'budget_max': budgetMax,
        'status': 'open',
      });
      state = const AsyncValue.data(null);
    } on PostgrestException catch (e, st) {
      state = AsyncValue.error('Erreur: ${e.message}', st);
    } catch (e, st) {
      state = AsyncValue.error('Erreur: $e', st);
    }
  }
}
