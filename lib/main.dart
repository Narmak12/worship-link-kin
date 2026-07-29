import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'services/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseClientService.initialize();
  await initializeDateFormatting('fr_FR', null);

  // Notifications push : ne bloque pas le démarrage de l'app si Firebase
  // n'est pas encore configuré (google-services.json manquant, etc.).
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Notification init error: $e');
  }

  runApp(const ProviderScope(child: WorshipLinkApp()));
}
