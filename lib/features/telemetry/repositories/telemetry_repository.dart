import 'package:fleet_pulse/core/utils/result.dart';
import 'package:fleet_pulse/features/telemetry/datasource/telemetry_datasource.dart';
import 'package:fleet_pulse/features/telemetry/models/create_telemetry_model.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';

class TelemetryRepository {
  final TelemetryDatasource _datasource;

  TelemetryRepository(this._datasource);

  Future<Result<TelemetryModel>> createTelemetry(
      CreateTelemetryModel telemetry) async {
    try {
      final result = await _datasource.createTelemetry(telemetry);
      return Success(result);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<TelemetryModel>> getTelemetryById(String id) async {
    try {
      final result = await _datasource.getTelemetryById(id);
      return Success(result);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<List<TelemetryModel>>> getRecentTelemetry({
    int hours = 24,
  }) async {
    try {
      final result = await _datasource.getRecentTelemetry(hours: hours);
      return Success(result);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<List<TelemetryModel>>> getTelemetryByVehicle(
    String vehicleId, {
    int limit = 100,
  }) async {
    try {
      final result = await _datasource.getTelemetryByVehicle(
        vehicleId,
        limit: limit,
      );
      return Success(result);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<List<TelemetryModel>>> getTelemetryByVehicleAndDateRange(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final result = await _datasource.getTelemetryByVehicleAndDateRange(
        vehicleId,
        startDate,
        endDate,
      );
      return Success(result);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}