import 'package:flutter/material.dart' hide Form;
import 'package:transacao/screen/form/form.dart';

class ButtonCard extends StatelessWidget{

  const ButtonCard({
    super.key
});

  @override
  Widget build(BuildContext context) {
      return
        ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Form()),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.5)
                ),

              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Nova Transação'),
                  ]

              )

          )
        ;

  }
}