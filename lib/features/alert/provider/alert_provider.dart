

import 'package:fleet_pulse/core/utils/result.dart';
import 'package:fleet_pulse/features/alert/datasource/alert_datasource.dart';
import 'package:fleet_pulse/features/alert/models/alert_model.dart';
import 'package:fleet_pulse/features/alert/repositories/alert_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  final datasource = ref.watch(alertDatasourceProvider);
  return AlertRepository(datasource);
});


final alertListProvider = FutureProvider<List<AlertModel>>((ref) async {
  final repository = ref.watch(alertRepositoryProvider);
  final result = await repository.fetchAlerts();

  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});


final alertListByVehicleProvider = FutureProvider.family<List<AlertModel>, String>((ref, vehicleId) async {
  final repository = ref.watch(alertRepositoryProvider);
  final result = await repository.fetchAlertsByVehicle(vehicleId);

  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});