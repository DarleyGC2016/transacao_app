import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transacao/constants/api_constants.dart';
import 'package:transacao/model/estatistica.dart';

class TransacaoService {



  Future<Estatistica> calcularEstatistica() async {


    try{
      final resp = await http.get(
          Uri.parse('${Apiconstants.baseUrlAndroid}api/desafio/transacoes')
      ).timeout(const Duration(seconds: 5));

      if (resp.statusCode == 200){

        return Estatistica.fromJson(jsonDecode(resp.body));
      }

      throw FormatException('Erro ao carregar dados. Códdigo: ${resp.statusCode}');
    }catch(e){
      if (e is FormatException){
        rethrow;
      }

      throw FormatException('Não foi possível conectar ao servidor');
    }


  }



}
