import 'package:fleet_pulse/core/api/api_client.dart';
import 'package:fleet_pulse/features/alert/models/alert_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertDatasource {
  final ApiClient _apiClient;

  AlertDatasource(this._apiClient);

  Future<List<AlertModel>> fetchAlerts() async {
    try {
      final response = await _apiClient.dio.get('/alerts');

      if (response.data['isSuccess'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AlertModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener alertas');
      }
    } catch (e) {
      throw Exception('Error de conexión');
    }
  }

  Future<List<AlertModel>> fetchAlertsByVehicle(String vehicleId) async {
    try {
      final response = await _apiClient.dio.get('/alert/vehicle/$vehicleId');

       return (response.data as List)
          .map((json) => AlertModel.fromJson(json as Map<String, dynamic>))
          .toList();
      } catch (e) {
        throw Exception('Error al obtener alertas del vehículo');
      }
  }
}

final alertDatasourceProvider = Provider<AlertDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AlertDatasource(apiClient);
});
