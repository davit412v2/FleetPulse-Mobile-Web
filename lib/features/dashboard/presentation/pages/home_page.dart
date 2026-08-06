import 'package:fleet_pulse/features/authentication/providers/auth_provider.dart';
import 'package:fleet_pulse/features/master_data/presentation/pages/master_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FleetPulse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      size: 60,
                      color: Color(0xFF0175C2),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Bienvenido!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if (user != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              user.fullName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Chip(
                              label: Text(user.role),
                              backgroundColor: user.role == 'Administrator'
                                  ? Colors.red.shade100
                                  : Colors.blue.shade100,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sección de Menú
            Text(
              'Menú Principal',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Opción Master Data
            _buildMenuCard(
              context,
              icon: Icons.storage,
              title: 'Datos Maestros',
              subtitle: 'Conductores, Vehículos y Rutas',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MasterDataPage()),
              ),
            ),

            const SizedBox(height: 12),

            // Opción Dashboard (Próximamente)
            _buildMenuCard(
              context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              subtitle: 'Vista general del sistema',
              color: Colors.green,
              onTap: null, // Deshabilitado por ahora
              isDisabled: true,
            ),

            const SizedBox(height: 12),

            // Opción Telemetría (Próximamente)
            _buildMenuCard(
              context,
              icon: Icons.sensors,
              title: 'Telemetría',
              subtitle: 'Datos en tiempo real',
              color: Colors.orange,
              onTap: null, // Deshabilitado por ahora
              isDisabled: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return Card(
      elevation: isDisabled ? 1 : 3,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isDisabled ? '$subtitle (Próximamente)' : subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: isDisabled ? Colors.grey : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}