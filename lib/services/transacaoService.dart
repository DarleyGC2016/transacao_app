import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transacao/model/estatistica.dart';

class Transacaoservice {

  Future<Estatistica> calcularEstatistica() async {
    final resp = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/desafio/transacoes')
    );

    if (resp.statusCode == 200){

      return Estatistica.fromJson(jsonDecode(resp.body));
    } else {

      throw Exception('Erro ao carregar dados');
    }
  }
}