import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class AuthService {
  final GoTrueClient _auth = supabase.auth;
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<void> sendOtp(String phone) async {
    try {
      await _auth.signInWithOtp(phone: phone, shouldCreateUser: true);
    } on AuthException catch (e) {
      throw _mapAuthError(e.message);
    }
  }

  Future<Session?> verifyOtp({required String phone, required String token}) async {
    try {
      final response = await _auth.verifyOTP(phone: phone, token: token, type: OtpType.sms);
      return response.session;
    } on AuthException catch (e) {
      throw _mapAuthError(e.message);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Connexion anonyme — permet de tester l'app sans SMS. À retirer avant
  /// une vraie mise en production (ce n'est pas une identité vérifiée).
  Future<Session?> signInAnonymously() async {
    try {
      final response = await _auth.signInAnonymously();
      return response.session;
    } on AuthException catch (e) {
      throw _mapAuthError(e.message);
    }
  }

  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    try {
      final res = await supabase.from('profiles').select().eq('id', userId).maybeSingle();
      return res;
    } catch (e) {
      return null;
    }
  }

  String _mapAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('expired')) return 'Le code a expiré.';
    if (lower.contains('incorrect')) return 'Code incorrect.';
    if (lower.contains('rate limit')) return 'Trop de tentatives.';
    return 'Erreur d\'authentification.';
  }
}
