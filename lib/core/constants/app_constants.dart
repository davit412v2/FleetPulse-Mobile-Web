class AppConstants {

  // API
  static const String baseUrl = 'http://localhost:5116/api';
  static const String apiVersion = 'v1';
  
  // WebSocket
  static const String wsUrl = 'ws://localhost:5116/ws';
  
  // Configuración
  static const int connectionTimeout = 30000; 
  static const int receiveTimeout = 30000;
  
  // Telemetría
  static const int telemetryUpdateInterval = 2; 
  static const int maxHistoryDays = 7;
  
  // Roles
  static const String roleAdmin = 'Administrator';
  static const String roleUser = 'User';
  
  // Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUser = 'user_data';
  static const String keyTheme = 'theme_mode';
}