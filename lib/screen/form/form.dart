import 'package:flutter/material.dart';

class Form extends StatelessWidget{

  const Form({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segunda Tela')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
          child: const Text('Voltar'),
        ),
      ),
    );
  }

}