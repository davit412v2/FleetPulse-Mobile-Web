import 'package:fleet_pulse/features/alert/enum/alert_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class AlertTypeConverter
    implements JsonConverter<AlertType, int> {
  const AlertTypeConverter();

  @override
  AlertType fromJson(int json) {
    switch (json) {
      case 1:
        return AlertType.lowFuel;
      case 2:
        return AlertType.highTemperature;

      default:
        return AlertType.lowFuel;
    }
  }

  @override
  int toJson(AlertType object) {
    return object.index + 1;
  }
}

class AlertSeverityConverter
    implements JsonConverter<AlertSeverity, int> {
  const AlertSeverityConverter();

  @override
  AlertSeverity fromJson(int json) {
    switch (json) {
      case 1:
        return AlertSeverity.info;
      case 2:
        return AlertSeverity.warning;
      case 3:
        return AlertSeverity.critical;
      default:
        return AlertSeverity.info;
    }
  }

  @override
  int toJson(AlertSeverity object) {
    return object.index + 1;
  }
}