import 'package:fleet_pulse/core/utils/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../datasource/master_data_datasource.dart';
import '../repositories/master_data_repository.dart';
import '../models/driver_model.dart';
import '../models/vehicle_model.dart';
import '../models/route_model.dart';

// ==================== PROVIDERS DE INSTANCIAS ====================

final masterDataDatasourceProvider = Provider<MasterDataDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MasterDataDatasource(apiClient);
});

final masterDataRepositoryProvider = Provider<MasterDataRepository>((ref) {
  final datasource = ref.watch(masterDataDatasourceProvider);
  return MasterDataRepository(datasource);
});

// ==================== FUTURE PROVIDERS PARA DATOS ====================

/// Provider para obtener todos los conductores
final driversProvider = FutureProvider<List<DriverModel>>((ref) async {
  final repository = ref.watch(masterDataRepositoryProvider);
  final result = await repository.getDrivers();
  
  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});

/// Provider para obtener todos los vehículos
final vehiclesProvider = FutureProvider<List<VehicleModel>>((ref) async {
  final repository = ref.watch(masterDataRepositoryProvider);
  final result = await repository.getVehicles();
  
  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});

/// Provider para obtener todas las rutas
final routesProvider = FutureProvider<List<RouteModel>>((ref) async {
  final repository = ref.watch(masterDataRepositoryProvider);
  final result = await repository.getRoutes();
  
  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});

// ==================== FAMILY PROVIDERS PARA CONSULTAS POR ID ====================

/// Provider para obtener un conductor por ID
final driverByIdProvider = FutureProvider.family<DriverModel, String>((ref, id) async {
  final repository = ref.watch(masterDataRepositoryProvider);
  final result = await repository.getDriverById(id);
  
  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});

/// Provider para obtener un vehículo por ID
final vehicleByIdProvider = FutureProvider.family<VehicleModel, String>((ref, id) async {
  final repository = ref.watch(masterDataRepositoryProvider);
  final result = await repository.getVehicleById(id);
  
  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});

/// Provider para obtener una ruta por ID
final routeByIdProvider = FutureProvider.family<RouteModel, String>((ref, id) async {
  final repository = ref.watch(masterDataRepositoryProvider);
  final result = await repository.getRouteById(id);
  
  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw Exception(result.errorOrNull);
  }
});