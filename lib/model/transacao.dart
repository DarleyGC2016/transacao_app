class Transacao {
  final double _valor;
  final String _dataHora;

  Transacao({required double valor, required String dataHora})
    : _dataHora = dataHora,
      _valor = valor;

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      valor: (json['valor'] as num).toDouble(),
      dataHora: json['dataHora'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'valor': _valor, 'dataHora': _dataHora};
  }
}
