import 'package:fleet_pulse/core/websocket/websocket_provider.dart';
import 'package:fleet_pulse/features/dashboard/provider/dashboard_state.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:fleet_pulse/features/telemetry/providers/telemetry_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    ref.listen(telemetryStreamProvider, (previous, next) {
      next.whenData((telemetry) {
        _updateTelemetry(telemetry);
      });
    });

    return const DashboardState();
  }

  void _updateTelemetry(TelemetryModel telemetry) {
    final updatedTelemetryMap = Map<String, TelemetryModel>.from(
      state.latestTelemetry,
    );
    updatedTelemetryMap[telemetry.vehicleId] = telemetry;

    // Actualiza el vehículo seleccionado si recibe telemetría en vivo
    TelemetryModel? updatedSelected = state.selectedTelemetry;
    if (state.selectedTelemetry?.vehicleId == telemetry.vehicleId) {
      updatedSelected = telemetry;
    }

    state = state.copyWith(
      latestTelemetry: updatedTelemetryMap,
      selectedTelemetry: updatedSelected,
    );
  }

  Future<void> selectVehicle(TelemetryModel telemetry) async {
    state = state.copyWith(
      selectedTelemetry: telemetry,
      isLoadingHistory: true,
      showVehicleHistory: true,
    );

    try {
      final history = await ref.read(
        telemetryByVehicleProvider(telemetry.vehicleId).future,
      );
      state = state.copyWith(
        vehicleHistory: history,
        isLoadingHistory: false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingHistory: false,
        showVehicleHistory: false,
      );
    }
  }

  void closeVehicleHistory() {
    state = state.copyWith(
      showVehicleHistory: false,
      selectedTelemetry: null,
      vehicleHistory: const [],
    );
  }
}