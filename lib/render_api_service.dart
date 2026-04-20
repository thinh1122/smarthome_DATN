import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'config.dart';

class RenderAPIService {
  static final RenderAPIService _instance = RenderAPIService._internal();
  factory RenderAPIService() => _instance;
  RenderAPIService._internal();

  final String _baseUrl = AppConfig.renderApiUrl;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'X-API-Key': AppConfig.renderApiKey,
  };

  // ============================================================
  // MEMBERS API
  // ============================================================

  /// Lấy danh sách members từ Render
  Future<List<Map<String, dynamic>>> getMembers() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/members'), headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      debugPrint('❌ Failed to fetch members: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching members: $e');
      return [];
    }
  }

  /// Đăng ký member mới lên Render
  Future<bool> enrollMember({
    required String userId,
    required String name,
    String role = 'Member',
    String? avatarUrl,
    String? pose1Url,
    String? pose2Url,
    String? pose3Url,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/members/enroll'),
            headers: _headers,
            body: jsonEncode({
              'user_id': userId,
              'name': name,
              'role': role,
              'avatar_url': avatarUrl,
              'pose1_url': pose1Url,
              'pose2_url': pose2Url,
              'pose3_url': pose3Url,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          debugPrint('✅ Member enrolled successfully: $name');
          return true;
        }
      }
      debugPrint('❌ Failed to enroll member: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('❌ Error enrolling member: $e');
      return false;
    }
  }

  /// Xóa member từ Render
  Future<bool> deleteMember(String userId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_baseUrl/members/$userId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          debugPrint('✅ Member deleted successfully: $userId');
          return true;
        }
      }
      debugPrint('❌ Failed to delete member: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('❌ Error deleting member: $e');
      return false;
    }
  }

  // ============================================================
  // FACE RECOGNITION API
  // ============================================================

  /// Lấy lịch sử nhận diện khuôn mặt
  Future<List<Map<String, dynamic>>> getFaceRecognitionHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/face-recognition/history?limit=$limit&offset=$offset'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      debugPrint('❌ Failed to fetch history: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching history: $e');
      return [];
    }
  }

  /// Ghi log nhận diện khuôn mặt
  Future<bool> logFaceRecognition({
    String? name,
    String? userId,
    required String action,
    required double confidence,
    bool isStranger = false,
    String? imageUrl,
    String location = 'front_door',
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/face-recognition/log'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'user_id': userId,
              'action': action,
              'confidence': confidence,
              'is_stranger': isStranger,
              'image_url': imageUrl,
              'location': location,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error logging face recognition: $e');
      return false;
    }
  }

  // ============================================================
  // DEVICE CONTROL API
  // ============================================================

  /// Điều khiển thiết bị qua Render (sẽ publish lên MQTT)
  Future<bool> controlDevice({
    required String deviceType,
    required String deviceName,
    required String action,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/devices/control'),
            headers: _headers,
            body: jsonEncode({
              'device_type': deviceType,
              'device_name': deviceName,
              'action': action,
              'payload': payload ?? {},
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          debugPrint('✅ Device controlled: $deviceType/$deviceName → $action');
          return true;
        }
      }
      debugPrint('❌ Failed to control device: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('❌ Error controlling device: $e');
      return false;
    }
  }

  /// Lấy trạng thái tất cả thiết bị
  Future<List<Map<String, dynamic>>> getDeviceStatus() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/devices/status'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching device status: $e');
      return [];
    }
  }

  // ============================================================
  // ANALYTICS API
  // ============================================================

  /// Lấy dữ liệu dashboard analytics
  Future<Map<String, dynamic>?> getDashboardAnalytics() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/analytics/dashboard'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching analytics: $e');
      return null;
    }
  }

  // ============================================================
  // HEALTH CHECK
  // ============================================================

  /// Kiểm tra Render backend có hoạt động không
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('${_baseUrl.replaceAll('/api', '')}/health'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'ok';
      }
      return false;
    } catch (e) {
      debugPrint('❌ Health check failed: $e');
      return false;
    }
  }
}
