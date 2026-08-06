import 'package:fleet_pulse/core/websocket/websocket_provider.dart';
import 'package:fleet_pulse/features/alert/widgets/alert_notification_bell.dart';
import 'package:fleet_pulse/features/dashboard/presentation/widgets/vehicle_details_panel.dart';
import 'package:fleet_pulse/features/dashboard/provider/dashboard_notifier.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signalr_netcore/signalr_client.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _vehicleIcon;

  static const LatLng _center = LatLng(4.6097, -74.0817);

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
  }

  Future<void> _loadMarkerIcon() async {
    _vehicleIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(32, 32)),
      'assets/images/truck.png',
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionStateProvider);
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final dashboardNotifier = ref.read(dashboardNotifierProvider.notifier);

    final markers = _buildMarkers(
      dashboardState.latestTelemetry,
      dashboardNotifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Monitoreo en Tiempo Real'),
        actions: [
          const AlertNotificationBell(),
          const SizedBox(width: 8),
          _buildConnectionStatus(connectionState),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  icon: Icons.local_shipping,
                  label: 'Vehículos Activos',
                  value: dashboardState.activeVehiclesCount.toString(),
                  color: Colors.blue,
                ),
                _buildStatCard(
                  icon: Icons.speed,
                  label: 'Velocidad Promedio',
                  value:
                      '${dashboardState.averageSpeed.toStringAsFixed(1)} km/h',
                  color: Colors.orange,
                ),
                _buildStatCard(
                  icon: Icons.sensors,
                  label: 'Actualizaciones',
                  value: dashboardState.latestTelemetry.length.toString(),
                  color: Colors.green,
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 700;

                // --- VISTA MÓVIL ---
                if (isMobile) {
                  return GoogleMap(
                    onMapCreated: (controller) => _mapController = controller,
                    initialCameraPosition: const CameraPosition(
                      target: _center,
                      zoom: 11.0,
                    ),
                    markers: markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: true,
                    zoomControlsEnabled: true,
                  );
                }

                // --- VISTA WEB / DESKTOP ---
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: GoogleMap(
                        onMapCreated: (controller) =>
                            _mapController = controller,
                        initialCameraPosition: const CameraPosition(
                          target: _center,
                          zoom: 11.0,
                        ),
                        markers: markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        mapToolbarEnabled: true,
                        zoomControlsEnabled: true,
                      ),
                    ),
                    if (dashboardState.showVehicleHistory &&
                        dashboardState.selectedTelemetry != null)
                      SizedBox(
                        width: 350,
                        child: dashboardState.isLoadingHistory
                            ? const Center(child: CircularProgressIndicator())
                            : VehicleDetailsPanel(
                                telemetry: dashboardState.selectedTelemetry!,
                                history: dashboardState.vehicleHistory,
                              ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _centerMapOnVehicles(markers),
        tooltip: 'Centrar en vehículos',
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Set<Marker> _buildMarkers(
    Map<String, TelemetryModel> telemetryMap,
    DashboardNotifier notifier,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return telemetryMap.values.map((telemetry) {
      return Marker(
        markerId: MarkerId(telemetry.vehicleId),
        position: LatLng(telemetry.latitude, telemetry.longitude),
        icon:
            _vehicleIcon ??
            BitmapDescriptor.defaultMarkerWithHue(
              _getMarkerColor(telemetry.speed),
            ),
        infoWindow: InfoWindow(
          title: telemetry.vehiclePlate,
          snippet:
              '${telemetry.speed.toStringAsFixed(1)} km/h | ${telemetry.fuelLevel.toStringAsFixed(0)} L',
        ),
        onTap: () {
          notifier.selectVehicle(telemetry);

          if (isMobile) {
            _showVehicleDetailsBottomSheet(context);
          }
        },
      );
    }).toSet();
  }

  double _getMarkerColor(double speed) {
    if (speed < 30) return BitmapDescriptor.hueGreen;
    if (speed < 60) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueRed;
  }

  Widget _buildConnectionStatus(
    AsyncValue<HubConnectionState> connectionState,
  ) {
    return connectionState.when(
      data: (state) {
        final isConnected = state == HubConnectionState.Connected;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: isConnected ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                isConnected ? 'En vivo' : 'Desconectado',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => const Icon(Icons.error, color: Colors.red),
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
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  void _centerMapOnVehicles(Set<Marker> markers) {
    if (markers.isEmpty || _mapController == null) return;

    final positions = markers.map((m) => m.position).toList();

    if (positions.length == 1) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(positions.first, 15),
      );
      return;
    }

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (var pos in positions) {
      if (pos.latitude < minLat) minLat = pos.latitude;
      if (pos.latitude > maxLat) maxLat = pos.latitude;
      if (pos.longitude < minLng) minLng = pos.longitude;
      if (pos.longitude > maxLng) maxLng = pos.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _showVehicleDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite controlar la altura de la hoja
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        // Usamos Consumer para escuchar los cambios de estado en tiempo real (p. ej. cuando termina de cargar el historial)
        return Consumer(
          builder: (context, ref, child) {
            final dashboardState = ref.watch(dashboardNotifierProvider);

            if (dashboardState.selectedTelemetry == null) {
              return const SizedBox.shrink();
            }

            return Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.75, // Ocupa el 75% de la pantalla
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Indicador visual de arrastre (Handle)
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Contenido del Panel
                  Expanded(
                    child: dashboardState.isLoadingHistory
                        ? const Center(child: CircularProgressIndicator())
                        : VehicleDetailsPanel(
                            telemetry: dashboardState.selectedTelemetry!,
                            history: dashboardState.vehicleHistory,
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
