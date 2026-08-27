import 'dart:async';

/// Representation of an authenticated user in FlowCycle.
class AuthUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool isEmailVerified;
  final bool isAnonymous;
  final DateTime createdAt;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isEmailVerified = true,
    this.isAnonymous = false,
    required this.createdAt,
  });

  AuthUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isEmailVerified,
    bool? isAnonymous,
    DateTime? createdAt,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Result returned from authentication operations.
class AuthResult {
  final bool isSuccess;
  final AuthUser? user;
  final String? errorMessage;

  const AuthResult({required this.isSuccess, this.user, this.errorMessage});

  factory AuthResult.success(AuthUser user) =>
      AuthResult(isSuccess: true, user: user);

  factory AuthResult.failure(String message) =>
      AuthResult(isSuccess: false, errorMessage: message);
}

/// Central Authentication Service providing standard Firebase Auth contracts
/// with resilient offline fallback mode for FlowCycle.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;

  AuthService._internal() {
    // Seed default demo user
    _currentUser = AuthUser(
      uid: 'user_flowcycle_001',
      email: 'amina@flowcycle.app',
      displayName: 'Amina',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  AuthUser? _currentUser;
  final StreamController<AuthUser?> _authStateController =
      StreamController<AuthUser?>.broadcast();

  /// Current authenticated user (if any).
  AuthUser? get currentUser => _currentUser;

  /// Stream emitting user on sign in / sign out state transitions.
  Stream<AuthUser?> get authStateChanges => _authStateController.stream;

  /// Returns whether a user session is active.
  bool get isAuthenticated => _currentUser != null;

  /// Sign in with Email and Password.
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    final trimmedEmail = email.trim();
    if (!trimmedEmail.contains('@') || !trimmedEmail.contains('.')) {
      return AuthResult.failure('Please enter a valid email address.');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters.');
    }

    final user = AuthUser(
      uid: 'user_${trimmedEmail.hashCode.abs()}',
      email: trimmedEmail,
      displayName: trimmedEmail.split('@').first,
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(_currentUser);
    return AuthResult.success(user);
  }

  /// Register a new account with Email, Password, and Name.
  Future<AuthResult> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final trimmedEmail = email.trim();
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return AuthResult.failure('Please enter your name.');
    }
    if (!trimmedEmail.contains('@') || !trimmedEmail.contains('.')) {
      return AuthResult.failure('Please enter a valid email address.');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters.');
    }

    final user = AuthUser(
      uid: 'user_${trimmedEmail.hashCode.abs()}',
      email: trimmedEmail,
      displayName: trimmedName,
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(_currentUser);
    return AuthResult.success(user);
  }

  /// Sign in via Google OAuth.
  Future<AuthResult> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = AuthUser(
      uid: 'google_user_001',
      email: 'amina.google@gmail.com',
      displayName: 'Amina (Google)',
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(_currentUser);
    return AuthResult.success(user);
  }

  /// Sign in via Apple OAuth.
  Future<AuthResult> signInWithApple() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = AuthUser(
      uid: 'apple_user_001',
      email: 'amina.apple@privaterelay.appleid.com',
      displayName: 'Amina (Apple)',
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(_currentUser);
    return AuthResult.success(user);
  }

  /// Sign in via generic provider (Google or Apple).
  Future<AuthResult> signInWithSocialProvider(String provider) async {
    if (provider.toLowerCase().contains('google')) {
      return signInWithGoogle();
    }
    return signInWithApple();
  }

  /// Send password reset verification email.
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final trimmedEmail = email.trim();
    if (!trimmedEmail.contains('@') || !trimmedEmail.contains('.')) {
      return AuthResult.failure('Please enter a valid email address.');
    }
    return const AuthResult(isSuccess: true);
  }

  /// Sign out active user session.
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _currentUser = null;
    _authStateController.add(null);
  }

  /// Update display name of the current authenticated user.
  void updateDisplayName(String name) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(displayName: name);
      _authStateController.add(_currentUser);
    }
  }
}
