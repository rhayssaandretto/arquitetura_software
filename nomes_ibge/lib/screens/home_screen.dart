import 'package:flutter/material.dart';
import 'package:ibge_nomes/screens/locality_names_screen.dart';
import 'package:ibge_nomes/screens/name_evolution_screen.dart';

import 'comparison_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análise de Nomes - IBGE')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            title: '1. Evolução do ranking de um nome',
            icon: Icons.show_chart,
            onTap: () => _navigateTo(context, const NameEvolutionScreen()),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            title: '2. Nomes mais frequentes por localidade',
            icon: Icons.location_on,
            onTap: () => _navigateTo(context, const LocalityNamesScreen()),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            title: '3. Comparar dois nomes (Brasil)',
            icon: Icons.compare_arrows,
            onTap: () => _navigateTo(context, const ComparisonScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
