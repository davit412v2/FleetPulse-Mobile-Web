import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';

class DashboardState {
  final Map<String, TelemetryModel> latestTelemetry;
  final TelemetryModel? selectedTelemetry;
  final List<TelemetryModel> vehicleHistory;
  final bool isLoadingHistory;
  final bool showVehicleHistory;

  const DashboardState({
    this.latestTelemetry = const {},
    this.selectedTelemetry,
    this.vehicleHistory = const [],
    this.isLoadingHistory = false,
    this.showVehicleHistory = false,
  });

  int get activeVehiclesCount => latestTelemetry.length;

  double get averageSpeed {
    if (latestTelemetry.isEmpty) return 0.0;
    final totalSpeed = latestTelemetry.values.fold<double>(
      0.0,
      (sum, item) => sum + item.speed,
    );
    return totalSpeed / latestTelemetry.length;
  }

  DashboardState copyWith({
    Map<String, TelemetryModel>? latestTelemetry,
    TelemetryModel? selectedTelemetry,
    List<TelemetryModel>? vehicleHistory,
    bool? isLoadingHistory,
    bool? showVehicleHistory,
  }) {
    return DashboardState(
      latestTelemetry: latestTelemetry ?? this.latestTelemetry,
      selectedTelemetry: selectedTelemetry ?? this.selectedTelemetry,
      vehicleHistory: vehicleHistory ?? this.vehicleHistory,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      showVehicleHistory: showVehicleHistory ?? this.showVehicleHistory,
    );
  }
}