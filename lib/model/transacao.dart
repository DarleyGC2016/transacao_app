class Transacao {
  double _valor;
  String _dataHora;

  void setValor(double value) {
    _valor = value;
  }

  void setDataHora(String value) {
    _dataHora = value;
  }

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
