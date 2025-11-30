import 'package:flutter/material.dart';
import 'package:smartcalc/widgets/buttons_widget.dart';
import 'package:smartcalc/widgets/text_field_widget.dart';
import 'package:smartcalc/widgets/result_widget.dart';

class SmartCalc extends StatefulWidget {
  const SmartCalc({super.key});

  @override
  State<SmartCalc> createState() {
    return _SmartCalcState();
  }
}

class _SmartCalcState extends State<SmartCalc> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> result = ValueNotifier<String>(
    '',
  ); // optional for result Widget.

  @override
  void dispose() {
    controller.dispose();
    result.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextFieldWidget(controller: controller),
          ResultWidget(result: result),
          Spacer(),
          ButtonsWidget(controller: controller, result: result),
        ],
      ),
    );
  }
}
