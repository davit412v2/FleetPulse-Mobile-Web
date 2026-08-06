import 'package:fleet_pulse/features/alert/models/alert_converter.dart';
import 'package:fleet_pulse/features/master_data/models/vehicle_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../enum/alert_enum.dart';


part 'alert_model.freezed.dart';
part 'alert_model.g.dart';

@freezed
class AlertModel with _$AlertModel {
  const AlertModel._(); 

  const factory AlertModel({
    required String id,
    required String vehicleId,
    String? telemetryId,
    VehicleModel? vehicle, 
    
    @AlertTypeConverter() required AlertType type,
    @AlertSeverityConverter() required AlertSeverity severity,
    required String title,
    required String message,
    required double value,
    required bool isRead,
    required DateTime timestamp,
  }) = _AlertModel;


  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);
}