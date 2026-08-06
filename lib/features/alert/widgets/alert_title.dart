import 'package:fleet_pulse/features/alert/models/alert_model.dart';
import 'package:flutter/material.dart';

class AlertItemTile extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onTap;

  const AlertItemTile({
    super.key,
    required this.alert,
    required this.onTap,
  });

  String _getSeverityDot(dynamic severity) {
    final String name = severity.toString().toLowerCase();
    if (name.contains('high') || name.contains('critical') || name.contains('red')) {
      return '🔴';
    } else if (name.contains('medium') || name.contains('warning') || name.contains('orange')) {
      return '🟠';
    }
    return '🟡';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: alert.isRead ? Colors.transparent : Colors.red.withOpacity(0.05),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _getSeverityDot(alert.severity),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alert.title,
                    style: TextStyle(
                      fontWeight:
                          alert.isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  alert.vehicle?.plate ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              alert.message,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              alert.value.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}