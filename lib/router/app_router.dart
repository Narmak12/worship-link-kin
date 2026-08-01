import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/enums.dart';
import '../providers/auth_provider.dart';
import '../screens/about_screen.dart';
import '../screens/auth/otp_verify_screen.dart';
import '../screens/auth/phone_input_screen.dart';
import '../screens/calendar/mission_calendar_screen.dart';
import '../screens/common/notifications_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/home/recruiter_home_screen.dart';
import '../screens/home/talent_home_screen.dart';
import '../screens/onboarding/church_profile_form_screen.dart';
import '../screens/onboarding/role_selection_screen.dart';
import '../screens/onboarding/talent_profile_form_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/profile/church_public_profile_screen.dart';
import '../screens/profile/favorites_screen.dart';
import '../screens/profile/talent_public_profile_screen.dart';
import '../screens/recruiter/church_edit_profile_screen.dart';
import '../screens/recruiter/create_job_screen.dart';
import '../screens/recruiter/my_jobs_screen.dart';
import '../screens/recruiter/recruiter_applications_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/talent/jobs_feed_screen.dart';
import '../screens/talent/my_applications_screen.dart';
import '../screens/talent/my_invitations_screen.dart';
import '../screens/talent/talent_edit_profile_screen.dart';
import '../screens/terms_screen.dart';
import '../screens/welcome_screen.dart';

/// Transforme un Stream (ici : les changements d'authentification Supabase)
/// en `Listenable`, ce que `GoRouter.refreshListenable` attend.
///
/// C'est LE correctif clé de navigation : avant, `routerProvider` recréait un
/// tout nouveau `GoRouter` à chaque connexion/déconnexion (via `ref.watch`
/// directement dans le `Provider`), ce qui effaçait toute la pile de
/// navigation à chaque fois (plus de bouton retour, plus d'accueil
/// accessible). Avec `refreshListenable`, le MÊME `GoRouter` reste en place
/// et se contente de ré-évaluer sa logique `redirect` — la pile de
/// navigation n'est plus détruite.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    refreshListenable: GoRouterRefreshStream(authService.onAuthStateChange),
    redirect: (context, state) {
      final user = ref.read(currentUserProvider);
      final isAuth = state.matchedLocation.startsWith('/auth');
      final isOnboarding = state.matchedLocation.startsWith('/onboarding');
      final isSplash = state.matchedLocation == '/';
      final isPublic = state.matchedLocation == '/welcome' || state.matchedLocation == '/about';

      if (user == null) {
        if (isAuth || isSplash || isPublic) return null;
        return '/welcome';
      }

      final profileAsync = ref.read(userProfileProvider);
      // Le profil est encore en cours de chargement : on ne redirige pas
      // encore pour éviter un aller-retour intempestif vers l'onboarding.
      if (profileAsync.isLoading && !profileAsync.hasValue) return null;

      final profile = profileAsync.valueOrNull;
      final isComplete = profile != null && profile.fullName.isNotEmpty && profile.fullName != 'Utilisateur';
      if (!isComplete && !isOnboarding && !isAuth) return '/onboarding/role';
      if (isComplete && (isAuth || isOnboarding || isSplash)) return profile.role == UserRole.talent ? '/home/talent' : '/home/recruiter';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: '/auth/phone', builder: (context, state) => PhoneInputScreen(role: state.extra as String? ?? 'talent')),
      GoRoute(path: '/auth/otp', builder: (context, state) => OtpVerifyScreen(phone: state.extra as String? ?? '')),
      GoRoute(path: '/onboarding/role', builder: (context, state) => const RoleSelectionScreen()),
      GoRoute(path: '/onboarding/talent-form', builder: (context, state) => const TalentProfileFormScreen()),
      GoRoute(path: '/onboarding/church-form', builder: (context, state) => const ChurchProfileFormScreen()),
      GoRoute(path: '/home/talent', builder: (context, state) => const TalentHomeScreen()),
      GoRoute(path: '/talent/applications', builder: (context, state) => const MyApplicationsScreen()),
      GoRoute(path: '/talent/invitations', builder: (context, state) => const MyInvitationsScreen()),
      GoRoute(path: '/talent/edit-profile', builder: (context, state) => const TalentEditProfileScreen()),
      GoRoute(path: '/talent/:id', builder: (context, state) => TalentPublicProfileScreen(talentId: state.pathParameters['id']!)),
      GoRoute(path: '/home/recruiter', builder: (context, state) => const RecruiterHomeScreen()),
      GoRoute(path: '/recruiter/create-job', builder: (context, state) => const CreateJobScreen()),
      GoRoute(path: '/recruiter/applications', builder: (context, state) => const RecruiterApplicationsScreen()),
      GoRoute(path: '/recruiter/my-jobs', builder: (context, state) => const MyJobsScreen()),
      GoRoute(path: '/recruiter/edit-profile', builder: (context, state) => const ChurchEditProfileScreen()),
      GoRoute(path: '/church/:id', builder: (context, state) => ChurchPublicProfileScreen(churchId: state.pathParameters['id']!)),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
      GoRoute(path: '/favorites', builder: (context, state) => const FavoritesScreen()),
      GoRoute(path: '/calendar', builder: (context, state) => const MissionCalendarScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
      GoRoute(path: '/terms', builder: (context, state) => const TermsScreen()),
      GoRoute(path: '/privacy', builder: (context, state) => const PrivacyScreen()),
      GoRoute(path: '/contact', builder: (context, state) => const ContactScreen()),
    ],
  );
});
