import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_client.dart';
import '../config/supabase_config.dart';
import 'auth_provider.dart';

final notificationsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return supabase.from(SupabaseConfig.notificationsTable).stream(primaryKey: ['id']).eq('user_id', user.id).order('created_at', ascending: false).map((d) => d);
});

final unreadCountProvider = StreamProvider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(0);
  return supabase.from(SupabaseConfig.notificationsTable).stream(primaryKey: ['id']).eq('user_id', user.id).eq('is_read', false).map((d) => d.length);
});

final notificationControllerProvider = StateNotifierProvider<NotificationController, AsyncValue<void>>((ref) => NotificationController());

class NotificationController extends StateNotifier<AsyncValue<void>> {
  NotificationController() : super(const AsyncValue.data(null));
  Future<void> markAsRead(String id) async {
    try { await supabase.from(SupabaseConfig.notificationsTable).update({'is_read': true}).eq('id', id); } catch (e) { debugPrint(e.toString()); }
  }
  Future<void> markAllAsRead() async {
    try {
      final user = supabase.auth.currentUser; if (user == null) return;
      await supabase.from(SupabaseConfig.notificationsTable).update({'is_read': true}).eq('user_id', user.id).eq('is_read', false);
    } catch (e) { debugPrint(e.toString()); }
  }
}
