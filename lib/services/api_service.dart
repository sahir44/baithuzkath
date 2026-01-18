import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://baithuzakath-api-uie39.ondigitalocean.app/api';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/beneficiary/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
    String mobile,
    String otp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/beneficiary/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': mobile, 'otp': otp}),
      );
      final data = json.decode(response.body);
      if (data['success'] == true && data['token'] != null) {
        await saveToken(data['token']);
      }
      return data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getSchemes() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/beneficiary/schemes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getSchemeDetails(String id) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/beneficiary/schemes/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> applyScheme(
    Map<String, dynamic> applicationData,
  ) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/beneficiary/applications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(applicationData),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getApplications() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/beneficiary/applications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> trackApplication(
    String applicationId,
  ) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/beneficiary/track/$applicationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/beneficiary/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final token = await getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/beneficiary/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
