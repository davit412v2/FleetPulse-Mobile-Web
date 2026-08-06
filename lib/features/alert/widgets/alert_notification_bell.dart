import 'package:fleet_pulse/features/alert/provider/alert_notifier.dart';
import 'package:fleet_pulse/features/alert/widgets/alert_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertNotificationBell extends ConsumerWidget {
  const AlertNotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertState = ref.watch(alertNotifierProvider);
    final notifier = ref.read(alertNotifierProvider.notifier);
    final unreadCount = alertState.unreadCount;

    return MenuAnchor(
      menuChildren: [
       SizedBox(
          width: 320,
          height: alertState.alerts.isEmpty ? 120 : 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '🚨 Alertas activas (${alertState.alerts.length})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (unreadCount > 0)
                      TextButton(
                        onPressed: () => notifier.markAllAsRead(),
                        child: const Text('Leídas', style: TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),

              Expanded(
                child: alertState.alerts.isEmpty
                    ? const Center(
                        child: Text(
                          'Sin alertas registradas',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: alertState.alerts.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final alert = alertState.alerts[index];
                          return AlertItemTile(
                            alert: alert,
                            onTap: () => notifier.markAsRead(alert.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
      builder: (context, controller, child) {
        return Badge(
          isLabelVisible: unreadCount > 0,
          label: Text('$unreadCount'),
          backgroundColor: Colors.red,
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
          ),
        );
      },
    );
  }
}

