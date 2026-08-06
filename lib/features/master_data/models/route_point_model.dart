import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_point_model.freezed.dart';
part 'route_point_model.g.dart';

@freezed
class RoutePointModel with _$RoutePointModel {
  const factory RoutePointModel({
    required double latitude,
    required double longitude,
    required int sequence,
  }) = _RoutePointModel;

  factory RoutePointModel.fromJson(Map<String, dynamic> json) =>
      _$RoutePointModelFromJson(json);
}