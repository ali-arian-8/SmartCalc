import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

class ButtonsWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueNotifier<String> result;

  const ButtonsWidget({
    super.key,
    required this.controller,
    required this.result,
  });

  @override
  State<ButtonsWidget> createState() => _ButtonsWidgetState();
}

class _ButtonsWidgetState extends State<ButtonsWidget> {
  final List<String> buttons = [
    'AC',
    '( )',
    '%',
    '÷',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '⌫',
    '=',
  ];

  final List<String> operators = ['+', '-', 'x', '÷'];

  Color color(String value) {
    if (value == 'AC') return const Color.fromARGB(255, 143, 1, 1);
    if (operators.contains(value))
      return const Color.fromARGB(255, 225, 160, 27);
    if (value == '=') return const Color.fromARGB(255, 26, 131, 12);
    if (value == '⌫') return const Color.fromARGB(255, 255, 143, 143);
    return const Color.fromARGB(255, 115, 113, 113);
  }

  int countOpenParentheses(String text) {
    int open = 0;
    for (final c in text.split('')) {
      if (c == '(') open++;
      if (c == ')') open--;
    }
    return open;
  }

  void evaluateLive(String text) {
    if (text.isEmpty || !text.contains(RegExp(r'[+\-x÷]'))) {
      widget.result.value = '';
      return;
    }

    String exp = text
        .replaceAllMapped(
          RegExp(r'(\d+(\.\d+)?)%'),
          (match) => '(${match.group(1)}/100)',
        )
        .replaceAll('x', '*')
        .replaceAll('÷', '/');

    try {
      Parser p = Parser();
      Expression expParsed = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expParsed.evaluate(EvaluationType.REAL, cm);
      widget.result.value = eval == eval.toInt()
          ? eval.toInt().toString()
          : eval.toString();
    } catch (_) {
      widget.result.value = '';
    }
  }

  void onButtonPressed(String value) {
    HapticFeedback.lightImpact();
    String text = widget.controller.text;
    String lastChar = text.isEmpty ? '' : text[text.length - 1];

    if (value == 'AC') {
      widget.controller.clear();
      widget.result.value = '';
      return;
    }

    if (value == '⌫') {
      if (text.isNotEmpty) {
        widget.controller.text = text.substring(0, text.length - 1);
        evaluateLive(widget.controller.text);
      }
      return;
    }

    if (value == '( )') {
      int unclosed = countOpenParentheses(text);
      if (unclosed > 0 && RegExp(r'[0-9)%]').hasMatch(lastChar)) {
        widget.controller.text += ')';
        evaluateLive(widget.controller.text);
        return;
      }
      if (lastChar.isEmpty || operators.contains(lastChar) || lastChar == '(') {
        widget.controller.text += '(';
        evaluateLive(widget.controller.text);
        return;
      }
      if (RegExp(r'[0-9)]').hasMatch(lastChar)) {
        widget.controller.text += 'x(';
        evaluateLive(widget.controller.text);
        return;
      }
      return;
    }

    if (operators.contains(value)) {
      if (text.isEmpty) {
        if (value == '-' || value == '+') {
          widget.controller.text += value;
          evaluateLive(widget.controller.text);
        }
        return;
      }
      if (operators.contains(lastChar)) {
        widget.controller.text = text.substring(0, text.length - 1) + value;
        evaluateLive(widget.controller.text);
        return;
      }
    }

    if (value == '.') {
      final match = RegExp(r'(\d+\.\d*)$').stringMatch(text);
      if (match != null) return;
    }

    if (value == '%') {
      if (text.isEmpty || operators.contains(lastChar) || text.endsWith('%'))
        return;
    }

    if (value == '=') {
      if (text.isEmpty ||
          operators.contains(lastChar) ||
          countOpenParentheses(text) != 0)
        return;

      String exp = text
          .replaceAllMapped(
            RegExp(r'(\d+(\.\d+)?)%'),
            (match) => '(${match.group(1)}/100)',
          )
          .replaceAll('x', '*')
          .replaceAll('÷', '/');

      try {
        Parser p = Parser();
        Expression expParsed = p.parse(exp);
        ContextModel cm = ContextModel();
        double eval = expParsed.evaluate(EvaluationType.REAL, cm);
        String result = eval == eval.toInt()
            ? eval.toInt().toString()
            : eval.toString();
        widget.controller.text = result;
        widget.result.value = '';
      } catch (e) {
        widget.result.value = 'Error';
      }
      return;
    }

    widget.controller.text += value;
    evaluateLive(widget.controller.text);
  }

  void onButtonLongPress(String value) {
    if (value == '⌫') {
      widget.controller.clear();
      widget.result.value = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromARGB(255, 58, 58, 58),
        child: GridView.builder(
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final button = buttons[index];
            return Semantics(
              label: 'Button $button',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color(button),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => onButtonPressed(button),
                onLongPress: () => onButtonLongPress(button),
                child: Text(
                  button,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
