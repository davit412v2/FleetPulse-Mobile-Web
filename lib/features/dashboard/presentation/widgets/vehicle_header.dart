import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleHeader extends StatelessWidget {
  final TelemetryModel telemetry;

  const VehicleHeader({
    super.key,
    required this.telemetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: theme.colorScheme.primaryContainer.withOpacity(.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(
                  Icons.local_shipping,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      telemetry.vehiclePlate,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      telemetry.routeName ?? "Sin ruta asignada",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                "Última actualización",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat(
              "dd/MM/yyyy HH:mm:ss",
            ).format(telemetry.timestamp.toLocal()),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}