import 'package:google_sign_in/google_sign_in.dart';

/// Wraps Google Sign-In to obtain an ID token for our backend
/// (POST /users/login/google). The serverClientId is the **Web** OAuth client
/// id — the ID token's audience, which the backend verifies.
class GoogleSignInService {
  GoogleSignInService._();
  static final GoogleSignInService instance = GoogleSignInService._();

  // Web/serverClientId from Google Cloud Console (project: bhaktibhoomi).
  static const String _serverClientId =
      '1049067408156-a59q0e108ub1mvkr7ttfl5avoe4ddilm.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _serverClientId,
    scopes: const ['email', 'profile'],
  );

  /// Starts the Google sign-in flow and returns the ID token, or null if the
  /// user cancels.
  Future<String?> signInGetIdToken() async {
    // Sign out first so the account chooser shows and we always get a fresh token.
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    final account = await _googleSignIn.signIn();
    if (account == null) return null; // cancelled
    final auth = await account.authentication;
    return auth.idToken;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
