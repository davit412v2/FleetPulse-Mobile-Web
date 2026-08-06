import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_telemetry_model.freezed.dart';
part 'create_telemetry_model.g.dart';

@freezed
class CreateTelemetryModel with _$CreateTelemetryModel {
  const factory CreateTelemetryModel({
    required String vehicleId,
    String? routeId,
    required double latitude,
    required double longitude,
    required double speed,
    required double fuelLevel,
    required double temperature,
    DateTime? timestamp,
  }) = _CreateTelemetryModel;

  factory CreateTelemetryModel.fromJson(Map<String, dynamic> json) =>
      _$CreateTelemetryModelFromJson(json);
}