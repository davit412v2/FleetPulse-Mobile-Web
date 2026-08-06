import '../../../core/utils/result.dart';
import '../datasource/master_data_datasource.dart';
import '../models/driver_model.dart';
import '../models/vehicle_model.dart';
import '../models/route_model.dart';

class MasterDataRepository {
  final MasterDataDatasource _datasource;

  MasterDataRepository(this._datasource);

  // ==================== DRIVERS ====================

  Future<Result<List<DriverModel>>> getDrivers() async {
    try {
      final drivers = await _datasource.getDrivers();
      return Success(drivers);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<DriverModel>> getDriverById(String id) async {
    try {
      final driver = await _datasource.getDriverById(id);
      return Success(driver);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  // ==================== VEHICLES ====================

  Future<Result<List<VehicleModel>>> getVehicles() async {
    try {
      final vehicles = await _datasource.getVehicles();
      return Success(vehicles);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<VehicleModel>> getVehicleById(String id) async {
    try {
      final vehicle = await _datasource.getVehicleById(id);
      return Success(vehicle);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  // ==================== ROUTES ====================

  Future<Result<List<RouteModel>>> getRoutes() async {
    try {
      final routes = await _datasource.getRoutes();
      return Success(routes);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<RouteModel>> getRouteById(String id) async {
    try {
      final route = await _datasource.getRouteById(id);
      return Success(route);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}