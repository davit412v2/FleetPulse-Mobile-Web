
import 'package:fleet_pulse/core/websocket/websocket_provider.dart';
import 'package:fleet_pulse/features/alert/models/alert_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertState {
  final List<AlertModel> alerts;

  const AlertState({this.alerts = const []});

  int get unreadCount => alerts.where((a) => !a.isRead).length;

  AlertState copyWith({List<AlertModel>? alerts}) {
    return AlertState(
      alerts: alerts ?? this.alerts,
    );
  }
}

final alertNotifierProvider =
    NotifierProvider<AlertNotifier, AlertState>(AlertNotifier.new);

class AlertNotifier extends Notifier<AlertState> {
  @override
  AlertState build() {
    // Escucha el Stream de WebSockets en tiempo real
    ref.listen(alertStreamProvider, (previous, next) {
      next.whenData((newAlert) {
        _onNewAlert(newAlert);
      });
    });

    return const AlertState();
  }

  void _onNewAlert(AlertModel newAlert) {
    // Evita duplicados por id y coloca la más reciente al inicio
    final currentAlerts = state.alerts.where((a) => a.id != newAlert.id).toList();
    state = state.copyWith(alerts: [newAlert, ...currentAlerts]);
  }

  void markAsRead(String alertId) {
    final updated = state.alerts.map((alert) {
      if (alert.id == alertId) {
        return alert.copyWith(isRead: true);
      }
      return alert;
    }).toList();

    state = state.copyWith(alerts: updated);
  }

  void markAllAsRead() {
    final updated = state.alerts.map((a) => a.copyWith(isRead: true)).toList();
    state = state.copyWith(alerts: updated);
  }
}