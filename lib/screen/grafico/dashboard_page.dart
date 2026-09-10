import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transacao/widgets/card/block_card.dart';
import 'package:transacao/widgets/dashboard/dashboard_grafico.dart';

import '../../model/estatistica.dart';
import '../../services/transacao_service.dart';

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

  @override
  void initState() {
    super.initState();

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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: BlockCard(
              icon: Icon(Icons.warning, color: Colors.white),
              title: 'Aviso',
              value: error is FormatException
                  ? error.message
                  : error.toString(),
              color: 0xFFFFD700,
            ),
          ),
        ],
      );
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
}
