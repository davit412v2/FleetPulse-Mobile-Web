import 'package:dio/dio.dart';
import 'package:fleet_pulse/core/api/api_client.dart';
import 'package:fleet_pulse/features/telemetry/models/create_telemetry_model.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TelemetryDatasource {
  final ApiClient _apiClient;

  TelemetryDatasource(this._apiClient);

  Future<TelemetryModel> createTelemetry(CreateTelemetryModel telemetry) async {
    try {
      final response = await _apiClient.dio.post(
        '/Telemetry',
        data: telemetry.toJson(),
      );
      return TelemetryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error al crear telemetría: ${e.message}');
    }
  }

  Future<TelemetryModel> getTelemetryById(String id) async {
    try {
      final response = await _apiClient.dio.get('/Telemetry/$id');
      return TelemetryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error al obtener telemetría: ${e.message}');
    }
  }

  Future<List<TelemetryModel>> getRecentTelemetry({int hours = 24}) async {
    try {
      final response = await _apiClient.dio.get(
        '/Telemetry/recent',
        queryParameters: {'hours': hours},
      );
      return (response.data as List)
          .map((json) => TelemetryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener telemetría reciente: ${e.message}');
    }
  }

  Future<List<TelemetryModel>> getTelemetryByVehicle(
    String vehicleId, {
    int limit = 100,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/Telemetry/vehicle/$vehicleId',
        queryParameters: {'limit': limit},
      );
      return (response.data as List)
          .map((json) => TelemetryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          'Error al obtener telemetría del vehículo: ${e.message}');
    }
  }

  Future<List<TelemetryModel>> getTelemetryByVehicleAndDateRange(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _apiClient.dio.get(
        '/Telemetry/vehicle/$vehicleId/range',
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );
      return (response.data as List)
          .map((json) => TelemetryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          'Error al obtener telemetría por rango de fechas: ${e.message}');
    }
  }
}


final telemetryDatasourceProvider = Provider<TelemetryDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TelemetryDatasource(apiClient);
});