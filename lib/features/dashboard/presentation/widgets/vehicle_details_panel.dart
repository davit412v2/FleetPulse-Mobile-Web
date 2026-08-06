import 'package:fleet_pulse/features/dashboard/presentation/widgets/vehicle_alerts_card.dart';
import 'package:fleet_pulse/features/dashboard/presentation/widgets/vehicle_header.dart';
import 'package:fleet_pulse/features/dashboard/presentation/widgets/vehicle_history_charts.dart';
import 'package:fleet_pulse/features/dashboard/presentation/widgets/vehicle_status_card.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:flutter/material.dart';

class VehicleDetailsPanel extends StatelessWidget {
  final TelemetryModel telemetry;
  final List<TelemetryModel> history;

  const VehicleDetailsPanel({
    super.key,
    required this.telemetry,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            /// Encabezado
            VehicleHeader(telemetry: telemetry),

            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    VehicleStatusCard(telemetry: telemetry),

                    const SizedBox(height: 16),

                    VehicleAlertsCard(vehicleId: telemetry.vehicleId),

                    const SizedBox(height: 16),

                    VehicleHistoryCharts(telemetry: history),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
