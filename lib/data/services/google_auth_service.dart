import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

const calendarEventsScope = 'https://www.googleapis.com/auth/calendar.events';
const calendarReadonlyScope =
    'https://www.googleapis.com/auth/calendar.readonly';

/// Manages Google authentication, account sessions, and authenticated HTTP clients.
///
/// On Android, Google Play Services manages the underlying refresh token securely.
/// Calling [signInSilently] will automatically restore or refresh the session
/// without displaying an account picker unless re-authentication is required.
class GoogleAuthService extends ChangeNotifier {
  GoogleAuthService._();

  static final GoogleAuthService instance = GoogleAuthService._();

  /// OAuth Client ID for Google Calendar authentication.
  /// Can be provided at build time via:
  /// `--dart-define=GOOGLE_CLIENT_ID=YOUR_CLIENT_ID.apps.googleusercontent.com`
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? googleClientId : null,
    scopes: const [
      'email',
      calendarEventsScope,
      calendarReadonlyScope,
    ],
  );

  GoogleSignInAccount? _currentUser;
  bool _initialized = false;

  bool get isInitialized => _initialized;
  bool get isSignedIn => _currentUser != null;
  GoogleSignInAccount? get currentUser => _currentUser;
  String? get userEmail => _currentUser?.email;
  String? get displayName => _currentUser?.displayName;
  String? get photoUrl => _currentUser?.photoUrl;

  Future<void> init() async {
    if (_initialized) return;

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
      notifyListeners();
    });

    try {
      _currentUser = await _googleSignIn.signInSilently();
    } catch (e) {
      debugPrint('[GoogleAuthService] Silent sign-in error: $e');
    }

    _initialized = true;
    notifyListeners();
  }

  /// Interactive sign-in flow.
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      _currentUser = account;
      notifyListeners();
      return account;
    } catch (e) {
      debugPrint('[GoogleAuthService] Interactive sign-in error: $e');
      rethrow;
    }
  }

  /// Obtains an authenticated HTTP client for calling Google APIs.
  /// Automatically injects fresh bearer tokens via Google Play Services.
  Future<AuthClient?> getAuthenticatedClient() async {
    var account = _currentUser;
    if (account == null) {
      account = await _googleSignIn.signInSilently();
      _currentUser = account;
    }
    if (account == null) return null;

    try {
      return await _googleSignIn.authenticatedClient();
    } catch (e) {
      debugPrint(
        '[GoogleAuthService] Failed to obtain authenticated client: $e',
      );
      return null;
    }
  }

  /// Signs the user out of Google on this device.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('[GoogleAuthService] Sign out error: $e');
    }
  }

  /// Fully disconnects the account, revoking granted OAuth permissions.
  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      debugPrint('[GoogleAuthService] Disconnect error: $e');
      // Still sign out locally even if remote revocation fails
      await _googleSignIn.signOut();
    }
    _currentUser = null;
    notifyListeners();
  }
}
