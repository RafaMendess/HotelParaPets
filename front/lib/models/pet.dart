class Pet {
  int id;
  String nome_tutor;
  String contato_tutor;
  String especie;
  String raca;
  DateTime data_entrada;
  DateTime? data_saida;

  Pet({
    required this.id,
    required this.nome_tutor,
    required this.contato_tutor,
    required this.especie,
    required this.raca,
    required this.data_entrada,
    this.data_saida,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as int,
      nome_tutor: json['nome_tutor'] as String,
      contato_tutor: json['contato_tutor'] as String,
      especie: json['especie'] as String,
      raca: json['raca'] as String,
      data_entrada: DateTime.parse(json['data_entrada']),
      data_saida: json['data_saida'] != null
          ? DateTime.parse(json['data_saida'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome_tutor': nome_tutor,
      'contato_tutor': contato_tutor,
      'especie': especie,
      'raca': raca,
      'data_entrada': data_entrada.toIso8601String(),
      'data_saida': data_saida?.toIso8601String(),
    };
  }

  int get diariasAteAgora {
 final hoje = DateTime.now();
  final fim = data_saida != null && data_saida!.isBefore(hoje) ? data_saida! : hoje;
  final diferenca = fim.difference(data_entrada).inDays;
  return diferenca > 0 ? diferenca : 0;
}


  int? get diariasPrevistas {
    if (data_saida == null) return null;

   final diferenca = data_saida?.difference(data_entrada).inDays;
  return diferenca! > 0 ? diferenca : 0;
  }
}
