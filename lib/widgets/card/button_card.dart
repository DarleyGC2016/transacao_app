import 'package:flutter/material.dart' hide Form;

class ButtonCard extends StatelessWidget {
  final String label;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onPressed;

  const ButtonCard({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // onPressed: () {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
      // },
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.5),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [?icon, Text(label)]),
        ],
      ),
    );
  }
}
