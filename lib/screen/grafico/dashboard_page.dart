import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transacao/widgets/card/block_card.dart';
import 'package:transacao/widgets/card/block_card_action.dart';
import 'package:transacao/widgets/dashboard/dashboard_grafico.dart';

import '../../model/estatistica.dart';
import '../../services/transacao_service.dart';
import '../form/form_transacao_page.dart' show FormTransacaoPage;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Future<Estatistica> estatisticaFuture;
  late NumberFormat _formato;
  late String msgNotFound;

  late double? _selectStartedFilter;

  @override
  void initState() {
    super.initState();
    msgNotFound = "NotFound";
    _selectStartedFilter = 0.1;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _atualizarDashboard();
    _formato = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Estatistica>(
        future: estatisticaFuture,
        builder: (context, snapshot) {
          return _resultadoEstatistica(snapshot);
        },
      ),
    );
  }

  Widget _resultadoEstatistica(AsyncSnapshot<Estatistica> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasData) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Resumo das Transações",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff0F172A),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 1.5,
            children: [
              Text(
                "Ultima transação: ${snapshot.data!.date} às ${snapshot.data!.time}",
                style: TextStyle(color: Colors.grey),
              ),
              IconButton(
                onPressed: () {
                  _infoGrafico(context);
                },
                icon: const Icon(Icons.info_outline),
                tooltip: "Informações",
              ),
            ],
          ),
          Flexible(
            child: DashboardGrafico(
              animation: _animation,
              numberFormat: _formato,
              estatistica: snapshot.data!,
              itemSelecionado: _selectStartedFilter!,
              onUpdate: () {
                _atualizarDashboard();
              },
            ),
          ),
        ],
      );
    }
    if (snapshot.hasError) {
      final error = snapshot.error;
      var msgError = '';
      if (error is FormatException) {
        msgError = error.message;
      }
      if (msgError.trim().toLowerCase() == msgNotFound.trim().toLowerCase()) {
        return Center(
          child: BlockCardAction(
            title: "Atenção",
            value:
                "Obs.: \tAinda não existe nenhuma Transação. Clique no botão e acima!",
            color: 0xFFFFD700,
            newScreen: FormTransacaoPage(),
            onUpdate: _atualizarDashboard,
            labelButton: "Nova Transação",
            icon: Icon(Icons.warning, color: Colors.white),
          ),
        );
      } else {
        return Center(
          child: BlockCard(
            icon: Icon(Icons.warning, color: Colors.white),
            title: 'Aviso',
            value: msgError,
            color: 0xFFFFD700,
          ),
        );
      }
    } else {
      Navigator.pop(context, true);
      return Text('');
    }
  }

  void _atualizarDashboard() {
    setState(() {
      estatisticaFuture = TransacaoService().calcularEstatistica();
      _controller.forward(from: 0.0);
    });
  }

  void _infoGrafico(BuildContext context) {
    final Map<double, String> opcoesNotas = {
      0.1: 'R\$ 0.10',
      1.0: 'R\$ 1,00',
      5.0: 'R\$ 5,00',
      10.0: 'R\$ 10,00',
      50.0: 'R\$ 50,00',
      100.00: 'R\$ 100,00',
      500.00: 'R\$ 500,00',
      1000.00: 'R\$ 1000,00',
      5000.00: 'R\$ 5000,00',
      10000.00: 'R\$ 10000,00',
    };

    double? valorAtual = opcoesNotas.containsKey(_selectStartedFilter)
        ? _selectStartedFilter
        : opcoesNotas.keys.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Gráfio Estatístico",
              style: TextStyle(
                color: Colors.green,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Color.from(alpha: 1, red: 0.8, green: 1, blue: 0.7),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "\tEscolha uma opção para visualizar o gráfico a partir do valor selecionado.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton<double>(
                      value: valorAtual,
                      items: opcoesNotas.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (double? value) {
                        if (value != null) {
                          setDialogState(() {
                            valorAtual = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          titleTextStyle: TextStyle(),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectStartedFilter = valorAtual;
                  _atualizarDashboard();
                  Navigator.pop(context, true);
                });
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
