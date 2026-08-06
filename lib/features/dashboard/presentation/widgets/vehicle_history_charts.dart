import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class VehicleHistoryCharts extends StatelessWidget {
  final List<TelemetryModel> telemetry;

  const VehicleHistoryCharts({
    super.key,
    required this.telemetry,
  });

  @override
  Widget build(BuildContext context) {
    if (telemetry.isEmpty) {
      return const Center(
        child: Text('No existe información histórica'),
      );
    }

    final orderedTelemetry = [...telemetry]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildVehicleInfo(orderedTelemetry.last),

            const SizedBox(height: 20),

            _buildSpeedChart(orderedTelemetry),

            const SizedBox(height: 30),

            _buildFuelChart(orderedTelemetry),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfo(TelemetryModel telemetry) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              telemetry.vehiclePlate,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (telemetry.routeName != null)
              Text(
                telemetry.routeName!,
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedChart(List<TelemetryModel> data) {
    return SizedBox(
      height: 280,
      child: SfCartesianChart(
        title: const ChartTitle(
          text: 'Histórico de Velocidad',
        ),
        legend: const Legend(
          isVisible: false,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.minutes,
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text: 'Km/h',
          ),
        ),
        series: [
          LineSeries<TelemetryModel, DateTime>(
            dataSource: data,
            xValueMapper: (t, _) => t.timestamp,
            yValueMapper: (t, _) => t.speed,
            markerSettings: const MarkerSettings(
              isVisible: true,
            ),
            dataLabelSettings: const DataLabelSettings(
              isVisible: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelChart(List<TelemetryModel> data) {
    return SizedBox(
      height: 280,
      child: SfCartesianChart(
        title: const ChartTitle(
          text: 'Histórico de Combustible',
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.minutes,
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text: 'Litros',
          ),
        ),
        series: [
          AreaSeries<TelemetryModel, DateTime>(
            dataSource: data,
            xValueMapper: (t, _) => t.timestamp,
            yValueMapper: (t, _) => t.fuelLevel,
            markerSettings: const MarkerSettings(
              isVisible: true,
            ),
          ),
        ],
      ),
    );
  }
}