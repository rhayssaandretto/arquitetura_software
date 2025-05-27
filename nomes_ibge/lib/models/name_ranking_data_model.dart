
class NameRankingData {
  final String nome;
  final int frequencia;
  final int ranking;

  NameRankingData({
    required this.nome,
    required this.frequencia,
    required this.ranking,
  });

  factory NameRankingData.fromJson(Map<String, dynamic> json) {
    return NameRankingData(
      nome: json['nome'] as String? ?? 'N/A',
      frequencia: json['frequencia'] as int? ?? 0,
      ranking: json['ranking'] as int? ?? 0,
    );
  }
}
