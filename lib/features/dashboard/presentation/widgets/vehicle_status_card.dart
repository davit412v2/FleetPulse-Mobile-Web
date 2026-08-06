import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:flutter/material.dart';

class VehicleStatusCard extends StatelessWidget {
  final TelemetryModel telemetry;

  const VehicleStatusCard({
    super.key,
    required this.telemetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.dashboard,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Estado del vehículo",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatusItem(
                    icon: Icons.speed,
                    title: "Velocidad",
                    value:
                        "${telemetry.speed.toStringAsFixed(1)} km/h",
                    color: _speedColor(telemetry.speed),
                  ),
                ),
                Expanded(
                  child: _StatusItem(
                    icon: Icons.local_gas_station,
                    title: "Combustible",
                    value:
                        "${telemetry.fuelLevel.toStringAsFixed(1)} L",
                    color: _fuelColor(telemetry.fuelLevel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatusItem(
                    icon: Icons.thermostat,
                    title: "Temperatura",
                    value:
                        "${telemetry.temperature.toStringAsFixed(1)} °C",
                    color: _temperatureColor(
                      telemetry.temperature,
                    ),
                  ),
                ),
                Expanded(
                  child: _StatusItem(
                    icon: Icons.location_on,
                    title: "Posición",
                    value:
                        "${telemetry.latitude.toStringAsFixed(4)}\n${telemetry.longitude.toStringAsFixed(4)}",
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Color _speedColor(double speed) {
    if (speed >= 80) return Colors.red;
    if (speed >= 60) return Colors.orange;
    return Colors.green;
  }

  static Color _fuelColor(double fuel) {
    if (fuel <= 15) return Colors.red;
    if (fuel <= 30) return Colors.orange;
    return Colors.green;
  }

  static Color _temperatureColor(double temp) {
    if (temp >= 95) return Colors.red;
    if (temp >= 85) return Colors.orange;
    return Colors.green;
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatusItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 34,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}