import 'package:flutter/material.dart';
import 'drivers_list_page.dart';
import 'vehicles_list_page.dart';
import 'routes_list_page.dart';

class MasterDataPage extends StatelessWidget {
  const MasterDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos Maestros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOptionCard(
              context,
              icon: Icons.person,
              title: 'Conductores',
              subtitle: 'Ver listado de conductores',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DriversListPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              icon: Icons.local_shipping,
              title: 'Vehículos',
              subtitle: 'Ver listado de vehículos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VehiclesListPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              icon: Icons.route,
              title: 'Rutas',
              subtitle: 'Ver listado de rutas',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RoutesListPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}