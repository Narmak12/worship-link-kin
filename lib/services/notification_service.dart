import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_messaging_service.dart';

class NotificationService {
  final _supabase = Supabase.instance.client;
  final _fcmService = FirebaseMessagingService();

  Future<void> initialize() async => await _fcmService.initialize();

  Future<void> sendToUser({required String recipientId, required String title, required String body, Map<String, dynamic>? data}) async {
    try {
      final tokens = await _supabase.from('notification_tokens').select('fcm_token').eq('user_id', recipientId);
      if (tokens.isEmpty) return;
      for (final t in tokens) {
        await _supabase.functions.invoke('send-push-notification', body: {
          'token': t['fcm_token'] as String, 'title': title, 'body': body,
          'data': {...?data, 'recipient_id': recipientId},
        });
      }
    } catch (e) { debugPrint('SendToUser error: $e'); }
  }

  Future<void> notifyNewApplication({required String recruiterId, required String talentName, required String jobTitle, required String jobId}) async {
    await sendToUser(recipientId: recruiterId, title: 'Nouvelle candidature', body: '$talentName a postulé à "$jobTitle"', data: {'type': 'new_application', 'job_id': jobId});
  }

  Future<void> notifyApplicationAccepted({required String talentId, required String churchName, required String jobTitle, required String jobId}) async {
    await sendToUser(recipientId: talentId, title: 'Candidature acceptée !', body: '$churchName a accepté votre candidature pour "$jobTitle"', data: {'type': 'application_accepted', 'job_id': jobId});
  }

  Future<void> notifyApplicationRejected({required String talentId, required String churchName, required String jobTitle}) async {
    await sendToUser(recipientId: talentId, title: 'Candidature non retenue', body: '$churchName a examiné votre candidature pour "$jobTitle"', data: {'type': 'application_rejected'});
  }

  Future<void> notifyNewInvitation({required String talentId, required String churchName, String? jobTitle}) async {
    await sendToUser(
      recipientId: talentId,
      title: 'Nouvelle invitation',
      body: jobTitle != null ? '$churchName vous invite pour "$jobTitle"' : '$churchName vous invite à collaborer',
      data: {'type': 'new_invitation'},
    );
  }

  Future<void> logout() async => await _fcmService.deleteToken();
}
