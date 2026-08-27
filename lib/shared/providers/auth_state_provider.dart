import 'package:flutter/foundation.dart';

/// Represents user authentication metadata and session state.
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userId,
    this.email,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Authentication state controller skeleton.
class AuthStateController extends ChangeNotifier {
  AuthState _state = const AuthState();

  AuthState get state => _state;

  void setLoggedIn({required String userId, required String email}) {
    _state = AuthState(isAuthenticated: true, userId: userId, email: email);
    notifyListeners();
  }

  void setLoggedOut() {
    _state = const AuthState();
    notifyListeners();
  }

  void setError(String message) {
    _state = _state.copyWith(errorMessage: message, isLoading: false);
    notifyListeners();
  }
}
