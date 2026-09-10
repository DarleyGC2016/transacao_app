import 'package:flutter/material.dart';

class ButtonLoadCard extends StatelessWidget {
  final bool flag;
  final bool iconTroca;

  final VoidCallback? onPressed;
  const ButtonLoadCard({
    super.key,
    required this.onPressed,
    required this.flag,
    this.iconTroca = false,
  });
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ElevatedButton(
        onPressed: flag ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: flag
            ? Center(
                child: const SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Se iconeNaEsquerda for true, renderiza o ícone, senão renderiza vazio
                  if (iconTroca) ...[
                    const Icon(Icons.check, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      "Salvar",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
