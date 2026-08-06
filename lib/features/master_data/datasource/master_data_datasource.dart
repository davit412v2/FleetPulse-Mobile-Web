import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/driver_model.dart';
import '../models/vehicle_model.dart';
import '../models/route_model.dart';

class MasterDataDatasource {
  final ApiClient _apiClient;

  MasterDataDatasource(this._apiClient);

  // ==================== DRIVERS ====================
  
  Future<List<DriverModel>> getDrivers() async {
    try {
      final response = await _apiClient.dio.get('/Drivers');
      final List<dynamic> data = response.data;
      return data.map((json) => DriverModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener conductores: ${e.message}');
    }
  }

  Future<DriverModel> getDriverById(String id) async {
    try {
      final response = await _apiClient.dio.get('/Drivers/$id');
      return DriverModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error al obtener conductor: ${e.message}');
    }
  }

  // ==================== VEHICLES ====================
  
  Future<List<VehicleModel>> getVehicles() async {
    try {
      final response = await _apiClient.dio.get('/Vehicles');
      final List<dynamic> data = response.data;
      return data.map((json) => VehicleModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener vehículos: ${e.message}');
    }
  }

  Future<VehicleModel> getVehicleById(String id) async {
    try {
      final response = await _apiClient.dio.get('/Vehicles/$id');
      return VehicleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error al obtener vehículo: ${e.message}');
    }
  }

  // ==================== ROUTES ====================
  
  Future<List<RouteModel>> getRoutes() async {
    try {
      final response = await _apiClient.dio.get('/Routes');
      final List<dynamic> data = response.data;
      return data.map((json) => RouteModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener rutas: ${e.message}');
    }
  }

  Future<RouteModel> getRouteById(String id) async {
    try {
      final response = await _apiClient.dio.get('/Routes/$id');
      return RouteModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error al obtener ruta: ${e.message}');
    }
  }
}