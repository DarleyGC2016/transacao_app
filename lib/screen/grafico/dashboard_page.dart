import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transacao/widgets/card/block_card.dart';
import 'package:transacao/widgets/dashboard/dashboard_grafico.dart';

import '../../model/estatistica.dart';
import '../../services/transacao_service.dart';
import '../../widgets/card/button_card.dart' show ButtonCard;
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

  @override
  void initState() {
    super.initState();
    msgNotFound = "NotFound";

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
      return DashboardGrafico(
        animation: _animation,
        numberFormat: _formato,
        estatistica: snapshot.data!,
        onUpdate: () {
          _atualizarDashboard();
        },
      );
    }
    if (snapshot.hasError) {
      final error = snapshot.error;
      var msgError = '';
      if (error is FormatException) {
        msgError = error.message;
      }
      if (msgError.trim().toLowerCase() == msgNotFound.trim().toLowerCase()) {
        return _avisoNovaTransacao(
          "Até este momento não foi registrada nenhuma transação!",
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: BlockCard(
                icon: Icon(Icons.warning, color: Colors.white),
                title: 'Aviso',
                value: msgError,
                color: 0xFFFFD700,
              ),
            ),
          ],
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

  Widget _avisoNovaTransacao(String mensagem) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: BlockCard(
              icon: Icon(Icons.warning, color: Colors.white),
              title: 'Aviso',
              value: mensagem,
              color: 0xFFFFD700,
            ),
          ),
          SizedBox(height: 20),
          ButtonCard(
            label: "Nova Transação",
            onPressed: () async {
              bool flag = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormTransacaoPage()),
              );

              if (flag == true) {
                _atualizarDashboard();
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
            buttonSize: Size(340, 100),
          ),
        ],
      ),
    );
  }
}
