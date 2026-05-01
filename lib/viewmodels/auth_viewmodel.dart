import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isMockAuthenticated = false;
  bool _isAdmin = false;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null || _isMockAuthenticated;
  bool get isAdmin => _isAdmin;

  AuthViewModel() {
    try {
      _authService.user.listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } catch (e) {
      print('AuthViewModel: Firebase auth not available. Operating in guest mode.');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    // Check for hardcoded Admin Login First
    if ((email == 'CHARLES_AUTOS' || email.toLowerCase() == 'charles_autos@gmail.com') && password == '0202275377') {
      _isMockAuthenticated = true;
      _isAdmin = true;
      _isLoading = false;
      notifyListeners();
      print('Using Admin login');
      return true;
    }

    try {
      final user = await _authService.signIn(email, password);
      _user = user;
      _isAdmin = false;
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      // Mock Login for testing
      if (email == 'test@charles.com' && password == 'password') {
        _isMockAuthenticated = true;
        _isAdmin = false;
        print('Using mock login');
      }
      _isLoading = false;
      notifyListeners();
      return email == 'test@charles.com'; // Success for mock account
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final user = await _authService.signUp(email, password);
      _user = user;
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    try {
      await _authService.signOut();
      _isMockAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _user = null;
      _isMockAuthenticated = false;
      notifyListeners();
    }
  }
}
