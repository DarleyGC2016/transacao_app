import 'package:flutter/material.dart';
import 'package:transacao/model/estatistica.dart';
import 'package:transacao/services/transacaoService.dart';

import 'MyHomePage.dart';

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Future<Estatistica> estatisticaFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    estatisticaFuture = Transacaoservice().calcularEstatistica();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: FutureBuilder<Estatistica>(
          future: estatisticaFuture

          , builder: (context, snapshot) {
            if ( snapshot.connectionState == ConnectionState.waiting) {
              return Center( child: CircularProgressIndicator());
            }
            final es = snapshot.data;
            return Center(
              child: Text('contador: ${es?.count}'
                  '\nSoma: ${es?.sum}'
              '\nMédia: ${es?.avg}'
              '\nMáximo: ${es?.getMax}'
              '\nMinimo: ${es?.getMin}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            );
          }
      ),
    );
  }
}