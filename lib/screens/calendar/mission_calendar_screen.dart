import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../config/theme.dart';
import '../../providers/matching_provider.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/talent_bottom_nav.dart';

class MissionCalendarScreen extends ConsumerWidget {
  const MissionCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(talentApplicationsProvider);

    return AppScaffold(
      title: 'Mon calendrier',
      body: appsAsync.when(
        data: (apps) {
          final accepted = apps.where((a) => a.isAccepted).toList();
          final events = <DateTime, List<String>>{};
          for (final app in accepted) {
            if (app.jobEventDate != null) {
              final d = DateTime(app.jobEventDate!.year, app.jobEventDate!.month, app.jobEventDate!.day);
              events[d] = [...(events[d] ?? []), app.jobTitle ?? 'Mission'];
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: DateTime.now(),
              eventLoader: (day) => events[DateTime(day.year, day.month, day.day)] ?? [],
              calendarStyle: CalendarStyle(
                markerDecoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: AppColors.deepBlue.withOpacity(0.2), shape: BoxShape.circle),
                selectedDecoration: const BoxDecoration(color: AppColors.deepBlue, shape: BoxShape.circle),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepBlue),
                formatButtonVisible: false,
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur')),
      ),
      bottomNavigationBar: const TalentBottomNav(currentIndex: 1),
    );
  }
}
