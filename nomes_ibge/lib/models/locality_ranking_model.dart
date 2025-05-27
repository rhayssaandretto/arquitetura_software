import 'package:ibge_nomes/models/name_ranking_data_model.dart';

class LocalityRanking {
  final String localidade;
  final String? sexo;
  final List<NameRankingData> res;

  LocalityRanking({required this.localidade, this.sexo, required this.res});

  factory LocalityRanking.fromJson(Map<String, dynamic> json) {
    return LocalityRanking(
      localidade: json['localidade'] as String? ?? '',
      sexo: json['sexo'] as String?,
      res:
          (json['res'] as List<dynamic>)
              .map((e) => NameRankingData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
