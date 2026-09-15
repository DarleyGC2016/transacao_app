import 'package:flutter/material.dart';

class ButtonLoadCard extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final bool flag;
  final double? textFontSize;
  final Size? buttonSize;
  final VoidCallback? onPressed;

  const ButtonLoadCard({
    super.key,
    required this.onPressed,
    required this.flag,
    this.backgroundColor,
    this.textColor,
    this.textFontSize,
    this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ElevatedButton(
        onPressed: flag ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: backgroundColor,
          textStyle: TextStyle(
            fontSize: textFontSize,
            fontWeight: FontWeight.bold,
          ),
          fixedSize: buttonSize,
        ),
        child: flag
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.lightBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.5),
                      Flexible(
                        child: Text(
                          "Aguarde...",
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, size: 20),
                  const SizedBox(width: 8),
                  Flexible(child: Text("Salvar")),
                ],
              ),
      ),
    );
  }
}
