import 'package:freezed_annotation/freezed_annotation.dart';
import 'route_point_model.dart';

part 'route_model.freezed.dart';
part 'route_model.g.dart';

@freezed
class RouteModel with _$RouteModel {
  const factory RouteModel({
    required String id,
    required String name,
    required String origin,
    required String destination,
    required double distance,
    required int estimatedTimeMinutes,
    required List<RoutePointModel> routePoints,
  }) = _RouteModel;

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
}