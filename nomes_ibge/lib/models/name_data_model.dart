import 'name_record_model.dart';

class NameData {
  final String nome;
  final String? sexo;
  final String localidade;
  final List<NameRecord> res;

  NameData({
    required this.nome,
    this.sexo,
    required this.localidade,
    required this.res,
  });

  factory NameData.fromJson(Map<String, dynamic> json) {
    return NameData(
      nome: json['nome'] ?? '',
      sexo: json['sexo'],
      localidade: json['localidade'] ?? '',
      res: (json['res'] as List).map((e) => NameRecord.fromJson(e)).toList(),
    );
  }
}
