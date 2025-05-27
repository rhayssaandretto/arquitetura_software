import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/name_data_model.dart';
import '../services/ibge_api_service.dart';
import '../widgets/line_chart_widget.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final _name1Controller = TextEditingController();
  final _name2Controller = TextEditingController();
  final _apiService = IbgeApiService();

  List<NameData> _namesData = [];
  bool _isLoading = false;
  String? _error;

  final List<Color> _chartColors = [Colors.redAccent, Colors.greenAccent];

  void _compareNames() async {
    final name1 = _name1Controller.text.trim();
    final name2 = _name2Controller.text.trim();

    if (name1.isEmpty || name2.isEmpty) {
      setState(() {
        _error = 'Digite os dois nomes.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _apiService.compareNames(name1, name2);
      setState(() {
        _namesData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao buscar dados.';
        _isLoading = false;
      });
    }
  }

  double _getMaxY() {
    double max = 0;
    for (var name in _namesData) {
      for (var res in name.res) {
        if (res.frequencia > max) {
          max = res.frequencia.toDouble();
        }
      }
    }
    return max * 1.2;
  }

  Widget _buildChart() {
    if (_namesData.isEmpty) {
      return const Text("Insira dois nomes para comparar.");
    }

    final allPeriods =
        _namesData
            .expand((name) => name.res.map((r) => r.periodo))
            .toSet()
            .toList()
          ..sort();
    final spotsList =
        _namesData.map((nameData) {
          return nameData.res.map((r) {
            final x = allPeriods.indexOf(r.periodo).toDouble();
            final y = r.frequencia.toDouble();
            return FlSpot(x, y);
          }).toList();
        }).toList();

    final legend = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_namesData.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: _chartColors[i % _chartColors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(_namesData[i].nome, style: const TextStyle(fontSize: 14)),
            ],
          ),
        );
      }),
    );

    return Column(
      children: [
        legend,
        const SizedBox(height: 12),
        LineChartWidget(
          spotsList: spotsList,
          periodLabels:
              allPeriods
                  .map((p) => p.replaceAll(RegExp(r'[\[\]]'), '').split(',')[0])
                  .toList(),
          chartColors: _chartColors,
          maxY: _getMaxY(),
          height: 400,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _name1Controller.dispose();
    _name2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comparar Nomes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _name1Controller,
              decoration: const InputDecoration(labelText: 'Nome 1'),
            ),
            TextField(
              controller: _name2Controller,
              decoration: const InputDecoration(labelText: 'Nome 2'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _compareNames,
              child: const Text('Comparar'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (!_isLoading && _error == null) _buildChart(),
          ],
        ),
      ),
    );
  }
}
