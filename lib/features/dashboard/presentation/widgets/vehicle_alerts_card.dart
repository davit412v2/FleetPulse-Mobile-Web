import 'package:fleet_pulse/features/alert/enum/alert_enum.dart';
import 'package:fleet_pulse/features/alert/models/alert_model.dart';
import 'package:fleet_pulse/features/alert/provider/alert_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleAlertsCard extends ConsumerWidget {
  final String vehicleId;

  const VehicleAlertsCard({
    super.key,
    required this.vehicleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(alertListByVehicleProvider(vehicleId));

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: alertsAsync.when(
          loading: () => const SizedBox(
            height: 80,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => SizedBox(
            height: 80,
            child: Center(
              child: Text(
                error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          data: (alerts) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Alertas activas",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: alerts.isEmpty
                          ? Colors.green
                          : Colors.red,
                      child: Text(
                        alerts.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (alerts.isEmpty)
                  const _EmptyAlertsWidget(),

                if (alerts.isNotEmpty)
                  ...alerts.map(
                    (alert) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AlertTile(alert: alert),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final AlertModel alert;

  const _AlertTile({
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          _icon(),
          color: _color(),
        ),
        title: Text(
          alert.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.message),
            const SizedBox(height: 4),
            Text(
              _value(),
              style: TextStyle(
                color: _color(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Icon(
          alert.isRead
              ? Icons.mark_email_read
              : Icons.mark_email_unread,
          color: Colors.grey,
        ),
      ),
    );
  }

  IconData _icon() {
    switch (alert.type) {
      case AlertType.lowFuel:
        return Icons.local_gas_station;

      default:
        return Icons.thermostat;
    }
  }

  Color _color() {
    switch (alert.severity) {
      case AlertSeverity.info:
        return Colors.blue;

      case AlertSeverity.warning:
        return Colors.orange;

      case AlertSeverity.critical:
        return Colors.red;
    }
  }

  Color _backgroundColor() {
    return _color().withOpacity(.08);
  }

  String _value() {
    return alert.value.toStringAsFixed(1);
  }
}

class _EmptyAlertsWidget extends StatelessWidget {
  const _EmptyAlertsWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 10),
            Text(
              "No existen alertas activas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}