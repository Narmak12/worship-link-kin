import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/enums.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/supabase_client.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authServiceProvider).onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.read(authServiceProvider).currentUser;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.read(authServiceProvider).isAuthenticated;
});

final userProfileProvider = FutureProvider<ProfileModel?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final data = await supabase.from('profiles').select().eq('id', user.id).single();
  return ProfileModel.fromJson(data);
});

final onboardingStateProvider = StateProvider<OnboardingState>((ref) => OnboardingState());

class OnboardingState {
  final String? phone, email, fullName, commune, bio, churchName, pastorName, category;
  final UserRole? selectedRole;
  OnboardingState({this.phone, this.email, this.selectedRole, this.fullName, this.commune, this.bio, this.churchName, this.pastorName, this.category});
  OnboardingState copyWith({String? phone, String? email, UserRole? selectedRole, String? fullName, String? commune, String? bio, String? churchName, String? pastorName, String? category}) {
    return OnboardingState(
      phone: phone ?? this.phone, email: email ?? this.email, selectedRole: selectedRole ?? this.selectedRole,
      fullName: fullName ?? this.fullName, commune: commune ?? this.commune, bio: bio ?? this.bio,
      churchName: churchName ?? this.churchName, pastorName: pastorName ?? this.pastorName, category: category ?? this.category,
    );
  }
}
