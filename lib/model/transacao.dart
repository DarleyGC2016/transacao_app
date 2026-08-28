class Transacao {
  late double _valor;
  late String _dataHora;

  double get valor => _valor;

  String get dataHora => _dataHora;

  set valor(double valor) {
    _valor = valor;
  }

  set dataHora(String dataHora) {
    _dataHora = dataHora;
  }
}
