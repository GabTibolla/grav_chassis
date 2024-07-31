// Definição do UpperCaseTextInputFormatter
import 'package:flutter/services.dart';

// Classe para formatar a entrada de texto. Só não permite letras minúsculas
class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
