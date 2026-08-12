import 'package:flutter/material.dart';

class BlockCard extends StatelessWidget{
  final String title;
  final String value;
  final int color;

  const BlockCard({
    super.key,
    required this.title, required this.value, required this.color
  });

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Color(color),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 10,
                offset: Offset(0, 6),
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center,
          children: [
            Text(
                title,
                style: TextStyle(color: Colors.white)
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff0F172A),
              ),
            ),

          ],
        ),
      );
  }

}