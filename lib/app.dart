import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'router/app_router.dart';
import 'router/notification_router.dart';

class WorshipLinkApp extends ConsumerWidget {
  const WorshipLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Worship Link Kin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) => NotificationRouter(child: child ?? const SizedBox.shrink()),
    );
  }
}
