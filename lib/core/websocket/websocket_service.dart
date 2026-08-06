import 'dart:async';
import 'package:fleet_pulse/core/storage/secure_storage.dart';
import 'package:fleet_pulse/features/alert/models/alert_model.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:signalr_netcore/signalr_client.dart';

class WebSocketService {
  static const String _hubUrl = 'http://192.168.1.152:5116/hubs/telemetry';

  HubConnection? _connection;
  final SecureStorage _secureStorage;

  final _telemetryController = StreamController<TelemetryModel>.broadcast();
  final _recentTelemetryController =
      StreamController<List<TelemetryModel>>.broadcast();
  final _connectionStateController =
      StreamController<HubConnectionState>.broadcast();
  final _alertController = StreamController<AlertModel>.broadcast();

  Stream<TelemetryModel> get telemetryStream => _telemetryController.stream;
  Stream<List<TelemetryModel>> get recentTelemetryStream =>
      _recentTelemetryController.stream;
  Stream<HubConnectionState> get connectionStateStream =>
      _connectionStateController.stream;
  Stream<AlertModel> get alertStream => _alertController.stream;

  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  WebSocketService(this._secureStorage);

  Future<void> connect() async {
    if (_connection != null && isConnected) {
      print('⚠️ WebSocket ya está conectado');
      return;
    }

    try {
      final token = await _secureStorage.getToken();

      if (token == null) {
        print('❌ No hay token de autenticación');
        return;
      }

      _connection = HubConnectionBuilder()
          .withUrl(
            _hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ),
          )
          .withAutomaticReconnect()
          .build();

      _connection!.onclose(({error}) {
        print('🔌 WebSocket desconectado: ${error ?? "Sin error"}');
        _connectionStateController.add(HubConnectionState.Disconnected);
      });

      _connection!.onreconnecting(({error}) {
        print('🔄 WebSocket reconectando...');
        _connectionStateController.add(HubConnectionState.Reconnecting);
      });

      _connection!.onreconnected(({connectionId}) {
        print('✅ WebSocket reconectado: $connectionId');
        _connectionStateController.add(HubConnectionState.Connected);
      });

      _connection!.on('ReceiveTelemetry', _onTelemetryReceived);
      _connection!.on('ReceiveRecentTelemetry', _onRecentTelemetryReceived);
      _connection!.on('ReceiveAlert', _onAlertReceived);

      await _connection!.start();
      _connectionStateController.add(HubConnectionState.Connected);
      print('✅ WebSocket conectado');
    } catch (e) {
      print('❌ Error al conectar WebSocket: $e');
      _connectionStateController.add(HubConnectionState.Disconnected);
    }
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection!.stop();
      _connection = null;
      print('🔌 WebSocket desconectado manualmente');
      _connectionStateController.add(HubConnectionState.Disconnected);
    }
  }

  Future<void> joinVehicleGroup(String vehicleId) async {
    if (!isConnected) {
      print('⚠️ WebSocket no está conectado');
      return;
    }

    try {
      await _connection!.invoke('JoinVehicleGroup', args: [vehicleId]);
      print('👥 Unido al grupo del vehículo: $vehicleId');
    } catch (e) {
      print('❌ Error al unirse al grupo: $e');
    }
  }

  Future<void> leaveVehicleGroup(String vehicleId) async {
    if (!isConnected) return;

    try {
      await _connection!.invoke('LeaveVehicleGroup', args: [vehicleId]);
      print('👥 Salió del grupo del vehículo: $vehicleId');
    } catch (e) {
      print('❌ Error al salir del grupo: $e');
    }
  }

  void _onTelemetryReceived(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) return;

    try {
      final data = arguments[0] as Map<String, dynamic>;
      final telemetry = TelemetryModel.fromJson(data);
      _telemetryController.add(telemetry);
      print('📡 Telemetría recibida: ${telemetry.vehiclePlate}');
    } catch (e) {
      print('❌ Error al procesar telemetría: $e');
    }
  }

  void _onRecentTelemetryReceived(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) return;

    try {
      final dataList = arguments[0] as List<dynamic>;
      final telemetryList = dataList
          .map((json) => TelemetryModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _recentTelemetryController.add(telemetryList);
      print(
        '📡 Telemetría reciente recibida: ${telemetryList.length} registros',
      );
    } catch (e) {
      print('❌ Error al procesar telemetría reciente: $e');
    }
  }

  void _onAlertReceived(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) return;

    try {
      final data = arguments.first as Map<String, dynamic>;

      final alert = AlertModel.fromJson(data);

      _alertController.add(alert);

      print('🚨 Alerta recibida: ${alert.title}');
    } catch (e) {
      print('❌ Error al procesar alerta: $e');
    }
  }

  void dispose() {
    _telemetryController.close();
    _recentTelemetryController.close();
    _connectionStateController.close();
    _alertController.close();
    disconnect();
  }
}
