import 'package:fleet_pulse/features/telemetry/providers/telemetry_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TelemetryListPage extends ConsumerWidget {
  const TelemetryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetryAsync = ref.watch(recentTelemetryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Telemetría Reciente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(recentTelemetryProvider),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: telemetryAsync.when(
        data: (telemetryList) {
          if (telemetryList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sensors_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay telemetría disponible',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: telemetryList.length,
            itemBuilder: (context, index) {
              final telemetry = telemetryList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getSpeedColor(telemetry.speed),
                    child: const Icon(Icons.local_shipping, color: Colors.white),
                  ),
                  title: Text(
                    telemetry.vehiclePlate,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.speed, size: 16),
                          const SizedBox(width: 4),
                          Text('${telemetry.speed.toStringAsFixed(1)} km/h'),
                          const SizedBox(width: 16),
                          const Icon(Icons.local_gas_station, size: 16),
                          const SizedBox(width: 4),
                          Text('${telemetry.fuelLevel.toStringAsFixed(1)} L'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.thermostat, size: 16),
                          const SizedBox(width: 4),
                          Text('${telemetry.temperature.toStringAsFixed(1)} °C'),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(_formatTimestamp(telemetry.timestamp)),
                        ],
                      ),
                      if (telemetry.routeName != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.route, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                telemetry.routeName!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: () {
                      // TODO: Mostrar en mapa (Feature 6: Dashboard)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'GPS: ${telemetry.latitude.toStringAsFixed(5)}, ${telemetry.longitude.toStringAsFixed(5)}',
                          ),
                        ),
                      );
                    },
                    tooltip: 'Ver ubicación',
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error al cargar telemetría',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(recentTelemetryProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSpeedColor(double speed) {
    if (speed < 30) return Colors.green;
    if (speed < 60) return Colors.orange;
    return Colors.red;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Ahora';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min';
    if (difference.inHours < 24) return '${difference.inHours} h';

    return DateFormat('dd/MM HH:mm').format(timestamp);
  }
}