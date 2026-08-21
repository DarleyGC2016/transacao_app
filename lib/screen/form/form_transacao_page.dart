import 'package:flutter/material.dart';

import '../../widgets/card/button_card.dart' show ButtonCard;
import '../grafico/dashboard_page.dart';

class FormTransacaoPage extends StatefulWidget {
  const FormTransacaoPage({super.key});

  @override
  State<FormTransacaoPage> createState() => _FormTransacaoPageState();
}

class _FormTransacaoPageState extends State<FormTransacaoPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário Da Transação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonCard(
                label: "Salvar",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
                icon: Icon(Icons.add),
                backgroundColor: Color.from(
                  alpha: 1,
                  red: 0.1,
                  green: 1,
                  blue: 0.4,
                ),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
