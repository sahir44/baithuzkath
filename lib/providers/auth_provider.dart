import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final token = await ApiService.getToken();
    if (token != null) {
      await loadProfile();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> sendOtp(String mobile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ApiService.sendOtp(mobile);

    _isLoading = false;
    if (response['success'] == true) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = response['message'] ?? 'Failed to send OTP';
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String mobile, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ApiService.verifyOtp(mobile, otp);

    if (response['success'] == true) {
      _isAuthenticated = true;
      await loadProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      _errorMessage = response['message'] ?? 'Invalid OTP';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadProfile() async {
    final response = await ApiService.getProfile();
    if (response['success'] == true && response['data'] != null) {
      _user = UserModel.fromJson(response['data']);
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await ApiService.clearToken();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
