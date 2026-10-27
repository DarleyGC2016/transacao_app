import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    show CurrencyTextInputFormatter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:intl/intl.dart' show DateFormat;
import 'package:transacao/model/transacao.dart';
import 'package:transacao/services/transacao_service.dart';
import 'package:transacao/widgets/input/input_moeda_br.dart';
import 'package:transacao/widgets/input/input_tempo.dart' show InputTempo;

import '../../widgets/card/button_card.dart' show ButtonCard;
import '../../widgets/card/button_load_card.dart' show ButtonLoadCard;

class FormTransacaoPage extends StatefulWidget {
  const FormTransacaoPage({super.key});

  @override
  State<FormTransacaoPage> createState() => _FormTransacaoPageState();
}

class _FormTransacaoPageState extends State<FormTransacaoPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
        locale: 'pt_BR',
        symbol: "R\$",
        decimalDigits: 2,
      );

  late double _moeda = 0.0;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TimeOfDay? _hora;
  late DateTime? _data;
  late bool _isCarregando;
  late final Transacao _transacao;

  @override
  void initState() {
    super.initState();
    _transacao = Transacao(valor: 0.0, dataHora: '');
    _isCarregando = false;
    _data = null;
    _hora = null;
    _dateController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Transação')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 32,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),

                    Text(
                      'Vamos registrar uma transação?',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Registre um valor e informe quando aconteceu.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    InputMoedaBr(
                      label: "Dinheiro",
                      moeda: _moeda,
                      validator: (moeda) {
                        if (moeda == null || moeda.isEmpty) {
                          return "Informe o valor do dinheiro!";
                        }
                        return null;
                      },
                      onChanged: (textFormattedUpdated) {
                        _changedMoeda(textFormattedUpdated);
                      },
                      textInputFormatter: <TextInputFormatter>[_formatter],
                    ),
                    SizedBox(height: 20),
                    InputTempo(
                      label: 'Data',
                      hintText: "dd/mm/aaaa",
                      colorIcon: Colors.amber,
                      icone: Icon(Icons.calendar_month_sharp),
                      validator: (data) {
                        if (data == null || data.isEmpty) {
                          return "Escolha uma data";
                        }
                        return null;
                      },
                      onTap: () {
                        _selectData(context);
                      },
                      timeController: _dateController,
                    ),
                    const SizedBox(height: 20),
                    InputTempo(
                      label: 'Hora',
                      hintText: "00:00",
                      colorIcon: Colors.blueAccent,
                      icone: Icon(Icons.access_time),
                      timeController: _timeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, selecione a hora";
                        }
                        return null;
                      },
                      onTap: () {
                        _selectHora(context);
                      },
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonLoadCard(
                          onPressed: _save,
                          flag: _isCarregando,
                          backgroundColor: Color.from(
                            alpha: 1,
                            red: 0.1,
                            green: 1,
                            blue: 0.4,
                          ),
                          textColor: Colors.white,
                          textFontSize: 20,
                          buttonSize: Size(160, 80),
                        ),
                        SizedBox(width: 10, height: 35),
                        ButtonCard(
                          label: "Cancelar",
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          icon: Icon(Icons.cancel),
                          backgroundColor: Color.from(
                            alpha: 1,
                            red: 1,
                            green: 0.1,
                            blue: 0.1,
                          ),
                          textColor: Colors.white,
                          textFontSize: 20,
                          buttonSize: Size(169, 80.9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime() {
    DateTime cliqueButton = DateTime.now();
    DateTime? dateTime = DateTime(
      _data!.year,
      _data!.month,
      _data!.day,
      _hora!.hour,
      _hora!.minute,
      cliqueButton.second,
      cliqueButton.millisecond,
    );
    return dateTime.toUtc().toIso8601String();
  }

  Future<void> _selectHora(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _timeController.text = time.format(context);
        _hora = time;
      });
    }
  }

  Future<void> _selectData(BuildContext context) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1976),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() {
        _data = data;
        _dateController.text = DateFormat('dd/MM/yyyy').format(data);
      });
    }
  }

  void _changedMoeda(String textFormattedUpdated) {
    setState(() {
      _formatter.formatString(
        textFormattedUpdated,
      ); // atualizar o valor da moeda.
      _transacao.setValor(_formatter.getUnformattedValue().toDouble());
    });
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isCarregando = true;
        });
        _transacao.setDataHora(_formatDateTime());
        final resp = await TransacaoService().save(_transacao);
        await Future.delayed(const Duration(seconds: 3));
        if (!mounted) {
          return;
        }
        switch (resp.statusCode) {
          case 201:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('${resp.body} 🎉')));
            Navigator.pop(context, true);
            break;
          case 422:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('${resp.body} 😡')));
            break;
          case 500:
            _moeda = 0;
            setState(() {
              _hora = null;
              _data = null;
            });

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('${resp.body} 🤬')));
            break;
        }
      } catch (e) {
        Navigator.pop(context, true);
      } finally {
        setState(() {
          _isCarregando = false;
        });
      }
    }
  }
}
