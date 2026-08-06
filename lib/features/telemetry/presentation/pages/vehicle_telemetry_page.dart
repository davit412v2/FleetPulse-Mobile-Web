import 'package:fleet_pulse/features/telemetry/providers/telemetry_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class VehicleTelemetryPage extends ConsumerWidget {
  final String vehicleId;
  final String vehiclePlate;

  const VehicleTelemetryPage({
    super.key,
    required this.vehicleId,
    required this.vehiclePlate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetryAsync = ref.watch(telemetryByVehicleProvider(vehicleId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Telemetría - $vehiclePlate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(telemetryByVehicleProvider(vehicleId)),
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
                    'No hay telemetría disponible para este vehículo',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Obtener última telemetría
          final latest = telemetryList.first;

          return Column(
            children: [
              // Resumen actual
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0175C2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0175C2)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Estado Actual',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          icon: Icons.speed,
                          label: 'Velocidad',
                          value: '${latest.speed.toStringAsFixed(1)} km/h',
                          color: Colors.blue,
                        ),
                        _buildStatCard(
                          icon: Icons.local_gas_station,
                          label: 'Combustible',
                          value: '${latest.fuelLevel.toStringAsFixed(1)} L',
                          color: Colors.green,
                        ),
                        _buildStatCard(
                          icon: Icons.thermostat,
                          label: 'Temperatura',
                          value: '${latest.temperature.toStringAsFixed(1)} °C',
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm').format(latest.timestamp)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Historial
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(width: 8),
                    Text(
                      'Historial (${telemetryList.length} registros)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: telemetryList.length,
                  itemBuilder: (context, index) {
                    final telemetry = telemetryList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getSpeedColor(telemetry.speed),
                          child: Text(
                            '${telemetry.speed.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          DateFormat('dd/MM/yyyy HH:mm:ss').format(telemetry.timestamp),
                        ),
                        subtitle: Text(
                          'Combustible: ${telemetry.fuelLevel.toStringAsFixed(1)} L | '
                          'Temp: ${telemetry.temperature.toStringAsFixed(1)} °C',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'GPS: ${telemetry.latitude.toStringAsFixed(5)}, ${telemetry.longitude.toStringAsFixed(5)}',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
                onPressed: () => ref.invalidate(telemetryByVehicleProvider(vehicleId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getSpeedColor(double speed) {
    if (speed < 30) return Colors.green;
    if (speed < 60) return Colors.orange;
    return Colors.red;
  }
}