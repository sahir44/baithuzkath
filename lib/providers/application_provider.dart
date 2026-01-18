import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/models/application_model.dart';

class ApplicationProvider with ChangeNotifier {
  List<ApplicationModel> _applications = [];
  ApplicationModel? _selectedApplication;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<ApplicationModel> get applications => _applications;
  ApplicationModel? get selectedApplication => _selectedApplication;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<void> loadApplications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ApiService.getApplications();

    _isLoading = false;
    if (response['success'] == true && response['data'] != null) {
      _applications = (response['data'] as List)
          .map((json) => ApplicationModel.fromJson(json))
          .toList();
    } else {
      _errorMessage = response['message'] ?? 'Failed to load applications';
    }
    notifyListeners();
  }

  Future<bool> submitApplication(String schemeId, String reason) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ApiService.applyScheme({
      'scheme_id': schemeId,
      'reason': reason,
    });

    _isSubmitting = false;
    if (response['success'] == true) {
      await loadApplications();
      notifyListeners();
      return true;
    } else {
      _errorMessage = response['message'] ?? 'Failed to submit application';
      notifyListeners();
      return false;
    }
  }

  Future<void> trackApplication(String applicationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ApiService.trackApplication(applicationId);

    _isLoading = false;
    if (response['success'] == true && response['data'] != null) {
      _selectedApplication = ApplicationModel.fromJson(response['data']);
    } else {
      _errorMessage = response['message'] ?? 'Failed to track application';
    }
    notifyListeners();
  }
}
