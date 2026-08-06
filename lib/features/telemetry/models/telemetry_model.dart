import 'package:freezed_annotation/freezed_annotation.dart';

part 'telemetry_model.freezed.dart';
part 'telemetry_model.g.dart';

@freezed
class TelemetryModel with _$TelemetryModel {
  const factory TelemetryModel({
    required String id,
    required String vehicleId,
    required String vehiclePlate,
    String? routeId,
    String? routeName,
    required double latitude,
    required double longitude,
    required double speed,
    required double fuelLevel,
    required double temperature,
    required DateTime timestamp,
  }) = _TelemetryModel;

  factory TelemetryModel.fromJson(Map<String, dynamic> json) =>
      _$TelemetryModelFromJson(json);
}