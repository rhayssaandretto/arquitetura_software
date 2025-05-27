import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/name_data_model.dart';

class IbgeApiService {
  final _baseUrl = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes';

  Future<List<NameData>> fetchNameEvolution(String name) async {
    final response = await http.get(Uri.parse('$_baseUrl/$name'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => NameData.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar dados do nome');
    }
  }

  Future<List<NameData>> fetchTopNamesEvolution(int locality) async {
  final rankingUrl = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=$locality';
  final rankingResponse = await http.get(Uri.parse(rankingUrl));
  if (rankingResponse.statusCode != 200) throw Exception("Erro no ranking");

  final rankingData = jsonDecode(rankingResponse.body)[0]["res"];
  final topNames = rankingData.take(3).map((e) => e["nome"]).toList();

  List<NameData> result = [];
  for (final name in topNames) {
    final historyUrl = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/$name?localidade=$locality';
    final historyResponse = await http.get(Uri.parse(historyUrl));
    if (historyResponse.statusCode != 200) continue;

    final historyData = jsonDecode(historyResponse.body)[0];
    result.add(NameData.fromJson(historyData));
  }

  return result;
}

  Future<List<NameData>> compareNames(String name1, String name2) async {
    final response = await http.get(Uri.parse('$_baseUrl/$name1|$name2'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => NameData.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao comparar nomes');
    }
  }
}
