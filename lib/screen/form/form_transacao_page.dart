import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    show CurrencyTextInputFormatter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:intl/intl.dart' show DateFormat;
import 'package:transacao/widgets/input/input_moeda_br.dart';
import 'package:transacao/widgets/input_tempo.dart';

import '../../widgets/card/button_card.dart' show ButtonCard;

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

  double _valorFinal = 0.0;
  String text = '';
  late DateTime _data;
  late TextEditingController _dateController;

  late TextEditingController _timeController;

  late TimeOfDay _hora;

  @override
  void initState() {
    super.initState();

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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Formulario'),

              InputMoedaBr(
                label: "Dinheiro",
                moeda: _valorFinal,
                validator: (moeda) {
                  if (moeda == null || moeda.isEmpty) {
                    return "Informe o valor do dinheiro!";
                  }
                  return null;
                },
                onChanged: (textFormattedUpdated) {
                  setState(() {
                    _formatter.formatString(
                      textFormattedUpdated,
                    ); // atualizar o valor da moeda.
                    _valorFinal = _formatter.getUnformattedValue().toDouble();
                  });
                },
                textInputFormatter: <TextInputFormatter>[_formatter],
              ),
              SizedBox(height: 20),
              InputTempo(
                label: 'Data',
                hintText: "dd/mm/yyyy",
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
                label: 'Horas',
                hintText: "00:00:00",
                icone: Icon(Icons.access_time),
                timeController: _timeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, selecione a horas";
                  }
                  return null;
                },
                onTap: () {
                  _selectHora(context);
                },
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonCard(
                    label: "Salvar",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final tempo = _formatDateTime();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(tempo)));
                      }
                    },
                    icon: Icon(Icons.save),
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
                  SizedBox(width: 10),
                  ButtonCard(
                    label: "Cancelar",
                    onPressed: () {
                      Navigator.pop(context);
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
                    buttonSize: Size(160, 80),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime() {
    DateTime? dateTime = _validaSegundo();
    if (dateTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Insira um novo minuto!')));
      return '';
    } else {
      Navigator.pop(context);
      return dateTime.toUtc().toIso8601String();
    }
  }

  DateTime? _validaSegundo() {
    DateTime cliqueButton = DateTime.now();
    if (cliqueButton.second >= 59) {
      return null;
    }
    return DateTime(
      _data.year,
      _data.month,
      _data.day,
      _hora.hour,
      _hora.minute,
      cliqueButton.second,
      cliqueButton.millisecond,
    );
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
}
