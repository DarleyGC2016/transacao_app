import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transacao/constants/api_constants.dart';
import 'package:transacao/model/estatistica.dart';

import '../model/transacao.dart';

class TransacaoService {
  Future<Estatistica> calcularEstatistica() async {
    try {
      final resp = await http
          .get(
            Uri.parse('${Apiconstants.baseUrlAndroid}api/desafio/transacoes'),
          )
          .timeout(const Duration(seconds: 5));

      if (resp.statusCode == 200) {
        return Estatistica.fromJson(jsonDecode(resp.body));
      } else {
        throw FormatException(resp.body);
      }
    } catch (e) {
      if (e is FormatException) {
        rethrow;
      }
      throw FormatException('Não foi possível conectar ao servidor');
    }
  }

  Future<http.Response> save(Transacao tr) async {
    final resp = await http.post(
      Uri.parse('${Apiconstants.baseUrlAndroid}api/desafio/transacao'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(tr.toJson()),
    );
    return resp;
  }
}
