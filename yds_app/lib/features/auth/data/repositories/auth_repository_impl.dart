import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  @override
  User? get currentUser => _supabaseClient.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _supabaseClient.auth.onAuthStateChange;
}
