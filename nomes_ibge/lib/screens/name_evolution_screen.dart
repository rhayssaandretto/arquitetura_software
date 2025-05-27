import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ibge_nomes/models/name_record_model.dart';

import '../services/ibge_api_service.dart';
import '../widgets/line_chart_widget.dart';

class NameEvolutionScreen extends StatefulWidget {
  const NameEvolutionScreen({super.key});

  @override
  State<NameEvolutionScreen> createState() => _NameEvolutionScreenState();
}

class _NameEvolutionScreenState extends State<NameEvolutionScreen> {
  final _nameController = TextEditingController();
  final _apiService = IbgeApiService();

  final List<int> _decades = [
    1930,
    1940,
    1950,
    1960,
    1970,
    1980,
    1990,
    2000,
    2010,
    2020,
  ];

  int? _startDecade;
  int? _endDecade;

  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> _rankingData = [];

  void _fetchRanking() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _error = 'Digite um nome.';
      });
      return;
    }

    if (_startDecade == null || _endDecade == null) {
      setState(() {
        _error = 'Selecione o intervalo de décadas.';
      });
      return;
    }

    if (_startDecade! > _endDecade!) {
      setState(() {
        _error = 'A década inicial deve ser menor ou igual à final.';
      });
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final dataList = await _apiService.fetchNameEvolution(name);

      if (dataList.isEmpty) {
        setState(() {
          _error = 'Nenhum dado encontrado para o nome.';
          _rankingData = [];
          _isLoading = false;
        });
        return;
      }

      final nameData = dataList.first;
      final List<NameRecord> records = nameData.res;

      final filtered =
          records.where((record) {
            final periodo = record.periodo;
            final startStr =
                periodo.replaceAll(RegExp(r'[\[\]]'), '').split(',')[0];
            final startYear = int.tryParse(startStr) ?? 0;
            return startYear >= _startDecade! && startYear <= _endDecade!;
          }).toList();

      if (filtered.isEmpty) {
        setState(() {
          _error = 'Não há dados disponíveis para o intervalo selecionado.';
          _rankingData = [];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _rankingData =
            filtered
                .map((r) => {'periodo': r.periodo, 'frequencia': r.frequencia})
                .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao buscar dados.';
        _isLoading = false;
      });
    }
  }

  List<FlSpot> _buildSpots() {
    return _rankingData.asMap().entries.map((entry) {
      final idx = entry.key.toDouble();
      final freq = (entry.value['frequencia'] as int).toDouble();
      return FlSpot(idx, freq);
    }).toList();
  }

  List<String> get _periodLabels =>
      _rankingData.map((e) {
        return (e['periodo'] as String)
            .replaceAll(RegExp(r'[\[\]]'), '')
            .split(',')[0];
      }).toList();

  int _getMaxFrequency() {
    if (_rankingData.isEmpty) return 10;
    int maxFreq = _rankingData
        .map((r) => r['frequencia'] as int)
        .reduce((a, b) => a > b ? a : b);
    return (maxFreq * 1.2).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evolução do nome'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _startDecade,
                    hint: const Text('Década inicial'),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                    items:
                        _decades
                            .map(
                              (dec) => DropdownMenuItem(
                                value: dec,
                                child: Text(dec.toString()),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => _startDecade = val),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _endDecade,
                    hint: const Text('Década final'),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                    items:
                        _decades
                            .map(
                              (dec) => DropdownMenuItem(
                                value: dec,
                                child: Text(dec.toString()),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => _endDecade = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _fetchRanking,
                  child: const Text('Mostrar'),
                ),
              ],
            ),

            const SizedBox(height: 20),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            if (!_isLoading && _rankingData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: SizedBox(
                  child: LineChartWidget(
                    spotsList: [_buildSpots()],
                    periodLabels: _periodLabels,
                    chartColors: [Colors.redAccent],
                    maxY: _getMaxFrequency().toDouble(),
                    height: 300,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
