import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  bool _isSignedIn = false;

  bool get isLoading => _isLoading;
  bool get isSignedIn => _isSignedIn;
  UserModel? get user => _user;

  Future<void> signInWithGoogle() async {
    final googleAuth = await _authService.selectGoogleAccount();
    if (googleAuth == null) return;

    _setLoading(true);
    _user = await _authService.signInWithGoogle(googleAuth);
    _setLoading(false);

    if (_user != null) {
      _isSignedIn = true;
    } else {
      _isSignedIn = false;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isSignedIn = false;
    notifyListeners();
  }

  Future<UserModel?> checkAuthStatus() async {
    return  await _authService.checkAuthStatus();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
