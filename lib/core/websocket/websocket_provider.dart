import 'package:fleet_pulse/core/storage/secure_storage.dart';
import 'package:fleet_pulse/core/websocket/websocket_service.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/signalr_client.dart';

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final service = WebSocketService(secureStorage);
  
  service.connect();
  
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

final connectionStateProvider = StreamProvider<HubConnectionState>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.connectionStateStream;
});

final telemetryStreamProvider = StreamProvider<TelemetryModel>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.telemetryStream;
});

final recentTelemetryStreamProvider = StreamProvider<List<TelemetryModel>>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.recentTelemetryStream;
});