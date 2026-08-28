import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transacao/model/estatistica.dart';

import '../../screen/form/form_transacao_page.dart';
import '../../widgets/card/block_card.dart';
import '../../widgets/card/button_card.dart';

class DashboardGrafico extends StatelessWidget {
  final Animation<double> animation;
  final NumberFormat numberFormat;
  final Estatistica estatistica;

  const DashboardGrafico({
    super.key,
    required this.animation,
    required this.numberFormat,
    required this.estatistica,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Resumo das Transações",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff0F172A),
            ),
          ),
          Text(
            "Ultima transação: ${estatistica.date} às ${estatistica.time}\n",
            style: TextStyle(color: Colors.grey),
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return _boxGraphic(estatistica);
            },
          ),
          const SizedBox(height: 30),
          _expandedCard(context),
        ],
      ),
    );
  }

  Widget _boxGraphic(Estatistica es) {
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
                dashArray: [6, 4],
              ),
            ],
          ),
          barGroups: es.values.asMap().entries.map((entry) {
            int index = entry.key;
            double value = entry.value * animation.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFFF00), Color(0xFF006400)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _expandedCard(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.8,
        children: [
          BlockCard(
            title: "Média",
            color: 0xFFFFA500,
            value: numberFormat.format(estatistica.avg),
            icon: Icon(
              Icons.analytics,
              shadows: [
                Shadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          BlockCard(
            title: "Máximo",
            value: numberFormat.format(estatistica.max),
            color: 0xFFFFD700,
            icon: Icon(
              Icons.trending_up,
              shadows: [
                Shadow(
                  color: Colors.white,
                  blurRadius: 7,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          BlockCard(
            title: "Mínimo",
            value: numberFormat.format(estatistica.min),
            color: 0xFF8B0000,
            icon: Icon(
              Icons.trending_down,
              shadows: [
                Shadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          BlockCard(
            title: "Total",
            value: numberFormat.format(estatistica.sum),
            color: 0xFF006400,
            icon: Icon(
              Icons.monetization_on,
              shadows: [
                Shadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          BlockCard(
            title: "Registros",
            value: estatistica.count.toString(),
            color: 0xff3B82F6,
            icon: Icon(
              Icons.numbers,
              shadows: [
                Shadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          ButtonCard(
            label: "Nova Transação",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormTransacaoPage()),
            ),
            icon: Icon(Icons.add),
            textFontSize: 18,
          ),
        ],
      ),
    );
  }
}
