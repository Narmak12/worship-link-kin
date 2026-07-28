import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

final supabase = Supabase.instance.client;

class SupabaseClientService {
  static Future<void> initialize() async {
    await Supabase.initialize(url: SupabaseConfig.supabaseUrl, anonKey: SupabaseConfig.supabaseAnonKey, debug: false);
  }
  static SupabaseClient get client => Supabase.instance.client;
}
