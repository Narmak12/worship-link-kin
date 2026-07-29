import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_client.dart';
import '../config/supabase_config.dart';
import '../models/application_model.dart';
import '../models/invitation_model.dart';
import '../services/notification_service.dart';
import 'auth_provider.dart';

final recruiterApplicationsProvider = StreamProvider<List<ApplicationModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return supabase.from('applications').select('''*, talent:profiles!applications_talent_id_fkey(id, full_name, avatar_url, phone, whatsapp, commune), job:jobs(id, title, specialite, event_date)''').eq('recruiter_id', user.id).order('created_at', ascending: false).asStream().map((d) => (d as List<dynamic>).map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>)).toList());
});

final talentApplicationsProvider = StreamProvider<List<ApplicationModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return supabase.from('applications').select('''*, job:jobs(id, title, specialite, event_date, status, recruiter_id, profiles:recruiter_id(church_name, full_name, avatar_url))''').eq('talent_id', user.id).order('created_at', ascending: false).asStream().map((d) => (d as List<dynamic>).map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>)).toList());
});

final hasAppliedProvider = FutureProvider.family<bool, String>((ref, jobId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  final res = await supabase.from('applications').select('id').eq('job_id', jobId).eq('talent_id', user.id).maybeSingle();
  return res != null;
});

final applicationControllerProvider = StateNotifierProvider<ApplicationController, AsyncValue<void>>((ref) => ApplicationController());

class ApplicationController extends StateNotifier<AsyncValue<void>> {
  ApplicationController() : super(const AsyncValue.data(null));
  Future<void> apply({required String jobId, required String talentId, required String message, int? proposedPrice}) async {
    state = const AsyncValue.loading();
    try {
      await supabase.from(SupabaseConfig.applicationsTable).insert({
        'job_id': jobId, 'talent_id': talentId,
        'message': message.trim().isEmpty ? null : message.trim(), 'proposed_price': proposedPrice,
      });
      final job = await supabase.from('jobs').select('recruiter_id, title, profiles:recruiter_id(full_name)').eq('id', jobId).single();
      final talent = await supabase.from('profiles').select('full_name').eq('id', talentId).single();
      NotificationService().notifyNewApplication(
        recruiterId: job['recruiter_id'] as String, talentName: talent['full_name'] as String,
        jobTitle: job['title'] as String, jobId: jobId,
      );
      state = const AsyncValue.data(null);
    } on PostgrestException catch (e, st) {
      if (e.code == '23505') state = AsyncValue.error('Vous avez déjà postulé.', st);
      else state = AsyncValue.error('Erreur: ${e.message}', st);
    } catch (e, st) { state = AsyncValue.error('Erreur: $e', st); }
  }

  Future<void> updateStatus({required String applicationId, required String newStatus}) async {
    state = const AsyncValue.loading();
    try {
      await supabase.from(SupabaseConfig.applicationsTable).update({'status': newStatus}).eq('id', applicationId);
      if (newStatus == 'accepted' || newStatus == 'rejected') {
        final appData = await supabase.from('applications').select('talent_id, job_id, job:jobs(title, profiles:recruiter_id(church_name, full_name))').eq('id', applicationId).single();
        final talentId = appData['talent_id'] as String;
        final churchName = (appData['job']['profiles']['church_name'] ?? appData['job']['profiles']['full_name']) as String;
        final jobTitle = appData['job']['title'] as String;
        if (newStatus == 'accepted') NotificationService().notifyApplicationAccepted(talentId: talentId, churchName: churchName, jobTitle: jobTitle, jobId: appData['job_id'] as String? ?? '');
        else NotificationService().notifyApplicationRejected(talentId: talentId, churchName: churchName, jobTitle: jobTitle);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) { state = AsyncValue.error('Erreur: $e', st); }
  }
}

final talentInvitationsProvider = StreamProvider<List<InvitationModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return supabase.from('invitations').select('''*, recruiter:profiles!invitations_recruiter_id_fkey(id, church_name, full_name, avatar_url, phone, whatsapp), job:jobs(id, title)''').eq('talent_id', user.id).order('created_at', ascending: false).asStream().map((d) => (d as List<dynamic>).map((e) => InvitationModel.fromJson(e as Map<String, dynamic>)).toList());
});

final invitationControllerProvider = StateNotifierProvider<InvitationController, AsyncValue<void>>((ref) => InvitationController());

class InvitationController extends StateNotifier<AsyncValue<void>> {
  InvitationController() : super(const AsyncValue.data(null));
  Future<void> invite({required String recruiterId, required String talentId, String? jobId, required String message, int? proposedPrice}) async {
    state = const AsyncValue.loading();
    try {
      await supabase.from(SupabaseConfig.invitationsTable).insert({
        'recruiter_id': recruiterId, 'talent_id': talentId, 'job_id': jobId,
        'message': message.trim().isEmpty ? null : message.trim(), 'proposed_price': proposedPrice,
      });
      final recruiter = await supabase.from('profiles').select('church_name, full_name').eq('id', recruiterId).single();
      final churchName = (recruiter['church_name'] ?? recruiter['full_name']) as String;
      NotificationService().notifyNewInvitation(talentId: talentId, churchName: churchName, jobTitle: null);
      state = const AsyncValue.data(null);
    } catch (e, st) { state = AsyncValue.error('Erreur: $e', st); }
  }
  Future<void> respond({required String invitationId, required bool accept}) async {
    state = const AsyncValue.loading();
    try {
      await supabase.from(SupabaseConfig.invitationsTable).update({'status': accept ? 'accepted' : 'declined'}).eq('id', invitationId);
      state = const AsyncValue.data(null);
    } catch (e, st) { state = AsyncValue.error('Erreur: $e', st); }
  }
}
