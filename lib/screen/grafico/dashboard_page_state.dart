import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../model/estatistica.dart';
import '../../services/transacao_service.dart';
import '../../widgets/card/block_card.dart';
import '../../widgets/card/button_card.dart';
import 'dashboard.dart';

class DashboardPageState  extends State<DashboardPage> with  SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  late Future<Estatistica> estatisticaFuture;
  late NumberFormat _formato;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(vsync: this, duration:  const Duration(milliseconds: 900));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    estatisticaFuture = TransacaoService().calcularEstatistica();
    _formato =  NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
    _controller.forward();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:FutureBuilder<Estatistica>(
            future: estatisticaFuture,
            builder: (context, snapshot){

              return _resultadoEstatistica(snapshot);
            })
    );
  }

  Widget _grafico (Estatistica es){
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Resumo das Transações",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff0F172A)
            ),
            ),
            Text(
              "Ultima transação: ${es.date} às ${es.time}\n",
              style: TextStyle(color: Colors.grey),
            ),
            AnimatedBuilder(
                animation: _animation,
                builder: (context, child){
                    return SizedBox(
                      height: 250,
                      child: BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: es.sum.ceilToDouble(),
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                  y: es.avg,
                                  color: Colors.redAccent.withValues(alpha: 0.45),
                                  strokeWidth: 2,
                                  dashArray: [6,4]
                              )
                            ]
                          ),
                          barGroups: es
                                     .values
                                     .asMap()
                                     .entries
                                     .map((entry) {
                                       int index = entry.key;
                                       double value = entry
                                                      .value * _animation.value;
                                       return BarChartGroupData(
                                         x: index,
                                         barRods: [
                                           BarChartRodData(
                                             toY: value,
                                             width: 18,
                                             borderRadius: BorderRadius.circular(6),
                                             gradient: LinearGradient(
                                               colors: [
                                                 Color(0xFFFFFF00),
                                                 Color(0xFF006400)

                                               ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                             )
                                           )
                                         ]
                                       );
                                     }).toList()
                        )
                      ),
                    );
                 },

                ),
              const SizedBox(height: 30,),
            Expanded(
                child: GridView
                       .count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 1.8,
                              children: [
                                BlockCard(
                                    title: "Média",
                                    color: 0xFFFFA500,
                                    value: _formato.format(es
                                        .avg)),
                                BlockCard(
                                    title: "Máximo",
                                    value: _formato
                                        .format(es
                                               .max
                                        ),
                                    color: 0xFFFFD700),
                                BlockCard(
                                    title: "Minimo",
                                    value: _formato
                                        .format(
                                                es
                                               .min
                                        ),
                                    color: 0xFF8B0000),
                                BlockCard(
                                    title: "Total",
                                    value: _formato
                                        .format(
                                                es
                                                .sum
                                        ),
                                    color: 0xFF006400),
                                BlockCard(
                                    title: "Registros",
                                    value: es
                                    .count
                                    .toString(),
                                    color: 0xff3B82F6),
                                ButtonCard()
                              ],
                       ))
          ],
        ),
    );
  }

  Widget _resultadoEstatistica(AsyncSnapshot<Estatistica> snapshot) {

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.hasError) {
      final error = snapshot.error;
      return  Center(
         child: Text(error is FormatException ? error.message : error.toString()),
      );

    }
    if (snapshot.hasData ){

      return _grafico(snapshot.data!);
    } else {

      return Center(
          child: Text("Nenhum dado encontrado!")
      );
    }
  }



}