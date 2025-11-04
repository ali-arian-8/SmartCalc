import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final ValueNotifier<String> result;
  const ResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromARGB(255, 58, 58, 58),
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerRight,
          child: ValueListenableBuilder<String>(
            valueListenable: result,
            builder: (_, value, __) => Text(
              value.isEmpty ? '' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color.fromARGB(255, 250, 227, 227),
                fontSize: 45,
              ),
            ),
          ),
        ),
      ),
    );
  }
}