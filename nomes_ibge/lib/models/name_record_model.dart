class NameRecord {
  final String periodo;
  final int frequencia;

  NameRecord({required this.periodo, required this.frequencia});

  factory NameRecord.fromJson(Map<String, dynamic> json) {
    return NameRecord(
      periodo: json['periodo'] ?? '',
      frequencia: json['frequencia'] ?? 0,
    );
  }
}
