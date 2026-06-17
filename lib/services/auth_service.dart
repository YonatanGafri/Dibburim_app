import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Replace this with the Web Client ID from Google Cloud Console
  // This is required for Google Sign-In to work with Supabase.
  static const String webClientId = '526122734696-mai73lea3n62ug5qj65raurggq4t4vec.apps.googleusercontent.com'; 

  /// Stream of authentication state changes.
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Get the current logged-in user.
  User? get currentUser => _supabase.auth.currentUser;

  /// Check if a user is currently logged in.
  bool get isLoggedIn => currentUser != null;

  /// Sign up with Email and Password
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'io.supabase.dibburim://login-callback',
    );
  }

  /// Sign in with Email and Password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Send a password reset email
  Future<void> resetPasswordForEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.dibburim://login-callback',
    );
  }

  /// Sign in with Google
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        scopes: ['email'],
      );
      
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in
      }
      
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Google Sign-In failed: Missing tokens.');
      }

      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    // Try signing out from Google as well (if logged in via Google)
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    
    // Sign out from Supabase
    await _supabase.auth.signOut();
  }

  /// Delete account (Calls an RPC function in Supabase)
  Future<void> deleteAccount() async {
    try {
      await _supabase.rpc('delete_user_account');
      await signOut();
    } catch (e) {
      debugPrint('Delete Account Error: $e');
      rethrow;
    }
  }
}
