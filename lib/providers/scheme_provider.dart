import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/models/scheme_model.dart';

class SchemeProvider with ChangeNotifier {
  List<SchemeModel> _schemes = [];
  SchemeModel? _selectedScheme;
  bool _isLoading = false;
  String? _errorMessage;

  List<SchemeModel> get schemes => _schemes;
  SchemeModel? get selectedScheme => _selectedScheme;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSchemes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ApiService.getSchemes();

    _isLoading = false;
    if (response['success'] == true && response['data'] != null) {
      _schemes = (response['data'] as List)
          .map((json) => SchemeModel.fromJson(json))
          .toList();
    } else {
      _errorMessage = response['message'] ?? 'Failed to load schemes';
    }
    notifyListeners();
  }

  Future<void> loadSchemeDetails(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ApiService.getSchemeDetails(id);

    _isLoading = false;
    if (response['success'] == true && response['data'] != null) {
      _selectedScheme = SchemeModel.fromJson(response['data']);
    } else {
      _errorMessage = response['message'] ?? 'Failed to load scheme details';
    }
    notifyListeners();
  }

  void clearSelectedScheme() {
    _selectedScheme = null;
    notifyListeners();
  }
}
