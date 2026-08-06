import 'package:fleet_pulse/core/api/api_client.dart';
import 'package:fleet_pulse/core/utils/result.dart';
import 'package:fleet_pulse/features/telemetry/datasource/telemetry_datasource.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:fleet_pulse/features/telemetry/repositories/telemetry_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final telemetryDatasourceProvider = Provider<TelemetryDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return TelemetryDatasource(dio);
});

final telemetryRepositoryProvider = Provider<TelemetryRepository>((ref) {
  final datasource = ref.watch(telemetryDatasourceProvider);
  return TelemetryRepository(datasource);
});

final recentTelemetryProvider = FutureProvider<List<TelemetryModel>>((ref) async {
  final repository = ref.watch(telemetryRepositoryProvider);
  final result = await repository.getRecentTelemetry(hours: 24);
  
  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});

final telemetryByVehicleProvider = FutureProvider.family<List<TelemetryModel>, String>(
  (ref, vehicleId) async {
    final repository = ref.watch(telemetryRepositoryProvider);
    final result = await repository.getTelemetryByVehicle(vehicleId, limit: 100);
    
    if (result.isSuccess) {
      return result.dataOrNull!;
    } else {
      throw Exception(result.errorOrNull);
    }
  },
);

final telemetryByIdProvider = FutureProvider.family<TelemetryModel, String>(
  (ref, telemetryId) async {
    final repository = ref.watch(telemetryRepositoryProvider);
    final result = await repository.getTelemetryById(telemetryId);
    
    if (result.isSuccess) {
      return result.dataOrNull!;
    } else {
      throw Exception(result.errorOrNull);
    }
  },
);