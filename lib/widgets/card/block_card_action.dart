import 'package:flutter/material.dart';

import 'button_card.dart' show ButtonCard;

class BlockCardAction extends StatelessWidget {
  final String title;
  final String value;
  final int color;
  final Widget? icon;
  final VoidCallback onUpdate;
  final Widget newScreen;
  final String labelButton;

  const BlockCardAction({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.newScreen,
    required this.onUpdate,
    required this.labelButton,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(color),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                if (icon != null) ...[icon!, SizedBox(width: 5)],
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ButtonCard(
              label: labelButton,
              onPressed: () async {
                bool flag = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => newScreen),
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
              buttonSize: Size(340, 100),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0F172A),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
