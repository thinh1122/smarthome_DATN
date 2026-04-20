class AppConfig {
  // HiveMQ MQTT Configuration
  // ⭐ THAY ĐỔI - Dán thông tin từ HiveMQ Console của bạn
  static const String hivemqHost = 'cff511c9b4b84e80dba6c5a4-c0fdc63.s1.eu.hivemq.cloud'; // ⚠️ Từ ảnh Console
  static const int hivemqPort = 8883;
  static const String hivemqUsername = 'smarthome'; // ⚠️ Từ ảnh của bạn
  static const String hivemqPassword = 'Smarthome123'; // ⚠️ Từ ảnh của bạn
  static const bool hivemqUseTLS = true;

  // Render Backend API
  static const String renderApiUrl = 'https://your-app.onrender.com/api'; // ⚠️ Thay bằng Render URL
  static const String renderApiKey = 'your_api_key'; // ⚠️ Thay bằng API key

  // Local Relay Server (khi ở nhà)
  static const String relayServerUrl = 'http://192.168.110.101:8080';
  
  // Python AI Server (local)
  static const String pythonAIUrl = 'http://192.168.110.101:5000';

  // ESP32-CAM
  static const String esp32IP = '192.168.110.38';
  static const int esp32Port = 81;

  // MQTT Topics
  static const String topicFaceRecognitionResult = 'home/face_recognition/result';
  static const String topicFaceRecognitionAlert = 'home/face_recognition/alert';
  static const String topicDeviceCommand = 'home/devices/{type}/{name}/command';
  static const String topicDeviceState = 'home/devices/{type}/{name}/state';
  static const String topicLogs = 'home/logs/activity';
  static const String topicAnalytics = 'home/analytics/stats';

  // App Settings
  static const int syncIntervalMinutes = 5; // Sync với Render mỗi 5 phút
  static const int maxLocalLogs = 100; // Giữ tối đa 100 logs local
  static const bool enableOfflineMode = true;
}
