import 'package:flutter/material.dart';
import 'package:ibge_nomes/models/name_data_model.dart';

import '../services/ibge_api_service.dart';

class LocalityNamesScreen extends StatefulWidget {
  const LocalityNamesScreen({super.key});

  @override
  State<LocalityNamesScreen> createState() => _LocalityNamesScreenState();
}

class _LocalityNamesScreenState extends State<LocalityNamesScreen> {
  final IbgeApiService _apiService = IbgeApiService();
  int? _selectedUfId;
  bool _isLoading = false;
  String? _error;
  List<NameData> _rankings = [];

  final List<Map<String, dynamic>> _ufs = [
    {'id': 11, 'nome': 'RO'},
    {'id': 12, 'nome': 'AC'},
    {'id': 13, 'nome': 'AM'},
    {'id': 14, 'nome': 'RR'},
    {'id': 15, 'nome': 'PA'},
    {'id': 16, 'nome': 'AP'},
    {'id': 17, 'nome': 'TO'},
    {'id': 21, 'nome': 'MA'},
    {'id': 22, 'nome': 'PI'},
    {'id': 23, 'nome': 'CE'},
    {'id': 24, 'nome': 'RN'},
    {'id': 25, 'nome': 'PB'},
    {'id': 26, 'nome': 'PE'},
    {'id': 27, 'nome': 'AL'},
    {'id': 28, 'nome': 'SE'},
    {'id': 29, 'nome': 'BA'},
    {'id': 31, 'nome': 'MG'},
    {'id': 32, 'nome': 'ES'},
    {'id': 33, 'nome': 'RJ'},
    {'id': 35, 'nome': 'SP'},
    {'id': 41, 'nome': 'PR'},
    {'id': 42, 'nome': 'SC'},
    {'id': 43, 'nome': 'RS'},
    {'id': 50, 'nome': 'MS'},
    {'id': 51, 'nome': 'MT'},
    {'id': 52, 'nome': 'GO'},
    {'id': 53, 'nome': 'DF'},
  ];

  void _loadRanking() async {
    if (_selectedUfId == null) {
      setState(() => _error = 'Selecione uma UF.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _rankings = [];
    });

    try {
      final data = await _apiService.fetchTopNamesEvolution(_selectedUfId!);
      setState(() {
        _rankings = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar dados.';
        _isLoading = false;
      });
    }
  }

  Widget _buildTable() {
    if (_rankings.isEmpty) {
      return const Center(child: Text("Nenhum dado de ranking para exibir."));
    }

    final top3Names = _rankings.take(3).toList();

    final Map<String, List<Map<String, dynamic>>> decadeMap = {};

    for (var nameData in top3Names) {
      for (var record in nameData.res) {
        final decada = _formatarPeriodo(record.periodo);
        decadeMap.putIfAbsent(decada, () => []);
        decadeMap[decada]!.add({
          'nome': nameData.nome,
          'frequencia': record.frequencia,
        });
      }
    }

    final List<DataRow> rows = [];

    for (var entry in decadeMap.entries) {
      final decada = entry.key;
      final registros = entry.value;

      for (int i = 0; i < registros.length; i++) {
        rows.add(
          DataRow(
            cells: [
              DataCell(i == 0 ? Text(decada) : const Text('')),
              DataCell(Text(registros[i]['nome'])),
              DataCell(Text(registros[i]['frequencia'].toString())),
            ],
          ),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Década')),
          DataColumn(label: Text('Nome')),
          DataColumn(label: Text('Frequência')),
        ],
        rows: rows,
      ),
    );
  }

  String _formatarPeriodo(String periodo) {
    return periodo
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(',', ' - ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking por Localidade')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Selecione a UF'),
              value: _selectedUfId,
              items:
                  _ufs
                      .map<DropdownMenuItem<int>>(
                        (uf) => DropdownMenuItem<int>(
                          value: uf['id'],
                          child: Text(uf['nome']),
                        ),
                      )
                      .toList(),
              onChanged: (val) => setState(() => _selectedUfId = val),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadRanking,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 24),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (!_isLoading && _rankings.isNotEmpty)
              Expanded(child: _buildTable()),
          ],
        ),
      ),
    );
  }
}
