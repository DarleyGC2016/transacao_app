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
  final VoidCallback onUpdate;

  const DashboardGrafico({
    super.key,
    required this.animation,
    required this.numberFormat,
    required this.estatistica,
    required this.onUpdate,
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
      height: 300,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: es.max.ceilToDouble() * 1.1,

          // Títulos dos eixos
          titlesData: FlTitlesData(
            // Eixo X
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 5.5,
                      fontStyle: FontStyle.normal,
                    ),
                  );
                },
              ),
            ),

            // Eixo Y esquerdo
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1000,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatarQuantidade(value),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),

            // Não mostrar eixo Y direito
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            // Não mostrar eixo superior
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          // Linha da média
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

          // Barras
          barGroups: es.values.asMap().entries.map((entry) {
            int index = entry.key;
            double value = entry.value * animation.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  width: 8,
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
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
        childAspectRatio: 1.5,
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: ButtonCard(
              label: "Nova Transação",
              onPressed: () async {
                final flag = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormTransacaoPage()),
                );

                if (flag == true) {
                  onUpdate();
                }
              },
              icon: Icon(
                Icons.monetization_on_outlined,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              backgroundColor: Color.from(
                alpha: 1,
                red: 0.8,
                green: 1,
                blue: 0.7,
              ),
              textFontSize: 25,
              buttonSize: Size(240, 160),
            ),
          ),
        ],
      ),
    );
  }

  String _formatarQuantidade(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }

    return value.toInt().toString();
  }
}
