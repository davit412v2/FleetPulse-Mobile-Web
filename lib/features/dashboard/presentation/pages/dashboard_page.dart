import 'dart:async';
import 'package:fleet_pulse/core/websocket/websocket_provider.dart';
import 'package:fleet_pulse/features/dashboard/presentation/widgets/vehicle_history_charts.dart';
import 'package:fleet_pulse/features/telemetry/models/telemetry_model.dart';
import 'package:fleet_pulse/features/telemetry/providers/telemetry_provider.dart';
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
  final Map<String, Marker> _markers = {};
  final Map<String, TelemetryModel> _latestTelemetry = {};
  BitmapDescriptor? _vehicleIcon;
  bool _showVehicleHistory = false;
  final List<TelemetryModel> historyTelemetry = [];

  static const LatLng _center = LatLng(4.6097, -74.0817);

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
    _listenToTelemetryStream();
  }

  Future<void> _loadMarkerIcon() async {
    _vehicleIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(32, 32)),
      'assets/images/truck.png',
    );
  }

  void _listenToTelemetryStream() {
    ref.listenManual(telemetryStreamProvider, (previous, next) {
      next.whenData((telemetry) {
        _updateMarker(telemetry);
      });
    });
  }

  void _updateMarker(TelemetryModel telemetry) {
    setState(() {
      _latestTelemetry[telemetry.vehicleId] = telemetry;

      final marker = Marker(
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
        onTap: () => _showTelemetryDetails(telemetry),
      );

      _markers[telemetry.vehicleId] = marker;
    });
  }

  double _getMarkerColor(double speed) {
    if (speed < 30) return BitmapDescriptor.hueGreen;
    if (speed < 60) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueRed;
  }

  void _showTelemetryDetails(TelemetryModel telemetry) {
    var telemetryProvider = ref.read(
      telemetryByVehicleProvider(telemetry.vehicleId).future,
    );

    historyTelemetry.clear();
    telemetryProvider
        .then((data) {
          setState(() {
            historyTelemetry.addAll(data);
            _showVehicleHistory = true;
          });
        })
        .catchError((error) {
          setState(() {
            _showVehicleHistory = false;
          });
        });

    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) => Container(
    //     padding: const EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Row(
    //           children: [
    //             const Icon(Icons.local_shipping, size: 32, color: Color(0xFF0175C2)),
    //             const SizedBox(width: 12),
    //             Text(
    //               telemetry.vehiclePlate,
    //               style: Theme.of(context).textTheme.headlineSmall,
    //             ),
    //           ],
    //         ),
    //         const Divider(height: 24),
    //         _buildDetailRow(Icons.speed, 'Velocidad', '${telemetry.speed.toStringAsFixed(1)} km/h'),
    //         _buildDetailRow(Icons.local_gas_station, 'Combustible', '${telemetry.fuelLevel.toStringAsFixed(1)} L'),
    //         _buildDetailRow(Icons.thermostat, 'Temperatura', '${telemetry.temperature.toStringAsFixed(1)} °C'),
    //         _buildDetailRow(Icons.location_on, 'Coordenadas', '${telemetry.latitude.toStringAsFixed(5)}, ${telemetry.longitude.toStringAsFixed(5)}'),
    //         if (telemetry.routeName != null)
    //           _buildDetailRow(Icons.route, 'Ruta', telemetry.routeName!),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Monitoreo en Tiempo Real'),
        actions: [
          connectionState.when(
            data: (state) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    state == HubConnectionState.Connected
                        ? Icons.wifi
                        : Icons.wifi_off,
                    color: state == HubConnectionState.Connected
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    state == HubConnectionState.Connected
                        ? 'En vivo'
                        : 'Desconectado',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const Icon(Icons.error, color: Colors.red),
          ),
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
                  value: _markers.length.toString(),
                  color: Colors.blue,
                ),
                _buildStatCard(
                  icon: Icons.speed,
                  label: 'Velocidad Promedio',
                  value: _calculateAverageSpeed(),
                  color: Colors.orange,
                ),
                _buildStatCard(
                  icon: Icons.sensors,
                  label: 'Actualizaciones',
                  value: _latestTelemetry.length.toString(),
                  color: Colors.green,
                ),
              ],
            ),
          ),

          // Mapa
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GoogleMap(
                    onMapCreated: (controller) => _mapController = controller,
                    initialCameraPosition: const CameraPosition(
                      target: _center,
                      zoom: 11.0,
                    ),
                    markers: Set<Marker>.of(_markers.values),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                ),

                if (_showVehicleHistory)
                  SizedBox(
                    width: 350,
                    child: VehicleHistoryCharts(
                      telemetry: historyTelemetry,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerMapOnVehicles,
        tooltip: 'Centrar en vehículos',
        child: const Icon(Icons.center_focus_strong),
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

  String _calculateAverageSpeed() {
    if (_latestTelemetry.isEmpty) return '0.0';

    final total = _latestTelemetry.values
        .map((t) => t.speed)
        .reduce((a, b) => a + b);
    final avg = total / _latestTelemetry.length;

    return '${avg.toStringAsFixed(1)} km/h';
  }

  void _centerMapOnVehicles() {
    if (_markers.isEmpty || _mapController == null) return;

    final positions = _markers.values.map((m) => m.position).toList();

    if (positions.length == 1) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(positions.first, 15),
      );
      return;
    }

    // Calcular bounds
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

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
