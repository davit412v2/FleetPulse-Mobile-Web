import 'package:fleet_pulse/core/utils/result.dart';
import 'package:fleet_pulse/features/alert/datasource/alert_datasource.dart';
import 'package:fleet_pulse/features/alert/models/alert_model.dart';

class AlertRepository {
  final AlertDatasource _datasource;

  AlertRepository(this._datasource);

  Future<Result<List<AlertModel>>> fetchAlerts() async {
    try {
      final result = await _datasource.fetchAlerts();

      return Success(result);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<List<AlertModel>>> fetchAlertsByVehicle(String vehicleId) async {
    try {
      final result = await _datasource.fetchAlertsByVehicle(vehicleId);

      return Success(result);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
