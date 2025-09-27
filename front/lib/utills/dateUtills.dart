String formatarDataParaBackend(String dataBrasil) {
  final partes = dataBrasil.split('/');
  if (partes.length != 3) return dataBrasil;

  final dia = partes[0].padLeft(2, '0');
  final mes = partes[1].padLeft(2, '0');
  final ano = partes[2];

  return '$ano-$mes-$dia';
}

DateTime parseDataBR(String data) {
  final partes = data.split('/');
  if (partes.length != 3) throw FormatException("Data inválida");
  final dia = int.parse(partes[0]);
  final mes = int.parse(partes[1]);
  final ano = int.parse(partes[2]);
  return DateTime(ano, mes, dia);
}

String formatarDataParaExibicao(DateTime data) {
  return "${data.day.toString().padLeft(2, '0')}/"
      "${data.month.toString().padLeft(2, '0')}/"
      "${data.year}";
}
