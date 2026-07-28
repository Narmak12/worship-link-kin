import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRouter extends StatefulWidget {
  final Widget child;
  const NotificationRouter({super.key, required this.child});
  @override
  State<NotificationRouter> createState() => _NotificationRouterState();
}

class _NotificationRouterState extends State<NotificationRouter> {
  @override
  void initState() {
    super.initState();
    _handleInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((message) { if (mounted) _navigate(message.data); });
  }

  Future<void> _handleInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null && mounted) _navigate(message.data);
  }

  void _navigate(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final router = GoRouter.of(context);
    switch (type) {
      case 'new_application': router.go('/recruiter/applications'); break;
      case 'application_accepted':
      case 'application_rejected': router.go('/talent/applications'); break;
      case 'new_invitation': router.go('/talent/invitations'); break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
