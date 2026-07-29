import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_client.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchCommuneProvider = StateProvider<String?>((ref) => null);
final searchCategoryProvider = StateProvider<String?>((ref) => null);
final searchAvailabilityProvider = StateProvider<bool?>((ref) => null);

final searchResultsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final commune = ref.watch(searchCommuneProvider);
  final category = ref.watch(searchCategoryProvider);
  final available = ref.watch(searchAvailabilityProvider);
  var dbQuery = supabase.from('profiles').select().eq('role', 'talent').eq('is_active', true);
  if (query.isNotEmpty) dbQuery = dbQuery.or('full_name.ilike.%$query%,bio.ilike.%$query%');
  if (commune != null && commune.isNotEmpty) dbQuery = dbQuery.eq('commune', commune);
  if (available != null) dbQuery = dbQuery.eq('is_available', available);
  if (category != null && category.isNotEmpty) dbQuery = dbQuery.ilike('bio', '%$category%');
  return await dbQuery.limit(50);
});
