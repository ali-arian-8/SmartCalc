// import 'package:flutter/material.dart';
//
// class ButtonsWidget extends StatelessWidget{
//   final TextEditingController controller;
//   final ValueNotifier<String> result;
//
//   const ButtonsWidget({
//     super.key,
//     required this.controller,
//     required this.result,
//
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     List<String> buttons = [
//       'AC', '( )', '%', '÷',
//       '7', '8', '9', 'x',
//       '4', '5', '6', '-',
//       '1', '2', '3', '+',
//       '0', '.', '⌫', '='
//     ];
//
//    Color color(String value){
//      if (value == 'AC'){
//        return Color.fromARGB(255, 143, 1, 1);
//      } if(value == '÷' || value=='x' || value =='-' || value == '+'){
//
//        return  Color.fromARGB(255, 225, 160, 27);
//      }if(value == '=') {
//        return Color.fromARGB(255, 26, 131, 12);
//      }if(value=='⌫'){
//
//        return Color.fromARGB(255, 255, 143, 143);
//
//      }
//      return Color.fromARGB(255, 115, 113, 113);
//    };
//
//     void onButtonPressed(String value){
//
//
//       List<String> operators =['+', '-', 'x', '÷'];
//       if( controller.text.isNotEmpty &&
//           operators.contains(controller.text[controller.text.length -1]) &&
//           operators.contains(value)
//       ){
//         controller.text = controller.text.substring(0,controller.text.length -1);
//         controller.text += value;
//         return;
//
//       }else if(value =='AC'){
//         controller.clear();
//         result.value='0';
//         return;
//       }else if(value == '⌫'){
//         final t= controller.text;
//         if(t.isNotEmpty) controller.text = t.substring(0,t.length -1);
//         return;
//       }else if(value == '='){
//         // Minimal evaluation placeholder (you’ll expand this later)
//          controller.text
//             .replaceAll('x', '*')
//             .replaceAll('÷', '/');
//         // Very basic guard; you’ll implement a real parser next
//          final expression = controller.text;
//         if(expression.trim().isEmpty){
//           result.value='0';
//           return;
//         }
//         // Keep it simple for now: show the input as "to be evaluated"
//         // Next step: parse and compute +, -, *, /
//         result.value = '...'; // replace with computed number when you add evaluator
//         return;
//       }
//       // Append normal input
//       controller.text += value;
//     }
//
//
//     return Expanded(
//       flex: 12,
//       child: Container(
//         height: double.infinity,
//         width: double.infinity,
//         alignment: Alignment.bottomCenter,
//         padding: EdgeInsets.all(10),
//         color: Color.fromARGB(255, 58, 58, 58),
//         child:
//             GridView.builder(
//             itemCount: buttons.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,
//             mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//             ),
//                 itemBuilder: (context,index) {
//               final button = buttons[index];
//              return ElevatedButton(style: ElevatedButton.styleFrom(
//                backgroundColor: color(button),
//                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
//                ),
//              ),
//                onPressed:()=>onButtonPressed(button),
//                     child: Text(button,
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold),
//                     ),
//                 );
//             }
//                   ),
//         ),
//       );
//   }
// }

import 'package:flutter/material.dart';

class ButtonsWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueNotifier<String> result;

  const ButtonsWidget({
    super.key,
    required this.controller,
    required this.result,
  });

  @override
  State<ButtonsWidget> createState() {
  return _ButtonsWidgetState();
  }

}
class _ButtonsWidgetState extends State<ButtonsWidget>{

    Widget build(BuildContext context) {
      List<String> buttons = [
        'AC', '( )', '%', '÷',
        '7', '8', '9', 'x',
        '4', '5', '6', '-',
        '1', '2', '3', '+',
        '0', '.', '⌫', '='
      ];

      // Determines button color based on its label
      Color color(String value) {
        if (value == 'AC') return const Color.fromARGB(255, 143, 1, 1);
        if (value == '÷' || value == 'x' || value == '-' || value == '+') {
          return const Color.fromARGB(255, 225, 160, 27);
        }
        if (value == '=') return const Color.fromARGB(255, 26, 131, 12);
        if (value == '⌫') return const Color.fromARGB(255, 255, 143, 143);
        return const Color.fromARGB(255, 115, 113, 113);
      }
      bool isOpenParenthesisNext = true;
      void onButtonPressed(String value) {
        List<String> operators = ['+', '-', 'x', '÷'];


        if (value == '( )') {
          
          // widget.controller.text += isOpenParenthesisNext ? '(' : ')';
          // isOpenParenthesisNext = !isOpenParenthesisNext;
          // return;
        }

        // Replace last operator if new one is also an operator
        if (widget.controller.text.isNotEmpty &&
            operators.contains(widget.controller.text[widget.controller.text.length - 1]) &&
            operators.contains(value)) {
          widget.controller.text = widget.controller.text.substring(0, widget.controller.text.length - 1);
          widget.controller.text += value;
          return;
        }

        // Clear input and result
        if (value == 'AC') {
          widget.controller.clear();
          widget.result.value = '0';
          return;
        }

        // Backspace deletes last character
        if (value == '⌫') {
          final t = widget.controller.text;
          if (t.isNotEmpty) {
            widget.controller.text = t.substring(0, t.length - 1);
          }
          return;
        }

        // Evaluate expression when '=' is pressed
        if (value == '=') {
          String expression = widget.controller.text;

          // Prevent empty input
          if (expression.trim().isEmpty) {
            widget.result.value = '0';
            return;
          }

          // Prevent ending with an operator
          if (operators.contains(expression[expression.length - 1])) {
            widget.result.value = 'Ends with operator';
            return;
          }

          // Prevent starting with an invalid operator (allow minus)
          if (operators.contains(expression[0]) && expression[0] != '-') {
            widget.result.value = 'Starts with invalid operator';
            return;
          }

          // Prevent multiple decimal points in a row
          if (expression.contains('..')) {
            widget.result.value = 'Invalid decimal';
            return;
          }

          // Prevent division by zero
          if (expression.contains('÷0')) {
            widget.result.value = 'Cannot divide by zero';
            return;
          }

          // Prevent invalid characters
          final validChars = RegExp(r'^[0-9+\-x÷().%]*$');
          if (!validChars.hasMatch(expression)) {
            widget.result.value = 'Invalid characters';
            return;
          }

          // Prevent unmatched parentheses
          int open = '('.allMatches(expression).length;
          int close = ')'.allMatches(expression).length;
          if (open != close) {
            widget.result.value = 'Unmatched parentheses';
            return;
          }

          // Prevent multiple percentage symbols in a row
          if (expression.contains('%%')) {
            widget.result.value = 'Invalid percentage';
            return;
          }

          // Prevent percentage symbol directly after an operator
          if (expression.length >= 2 &&
              operators.contains(expression[expression.length - 2]) &&
              expression[expression.length - 1] == '%') {
            widget.result.value = 'Invalid use of %';
            return;
          }

          // Prevent starting with %, ., or )
          if (expression.isNotEmpty &&
              (expression[0] == '%' || expression[0] == '.' || expression[0] == ')')) {
            widget.result.value = 'Cannot start with ' + expression[0];
            return;
          }

          // Prevent empty or invalid parentheses like (), (+), etc.
          if (expression.contains('()') ||
              expression.contains('(+)') ||
              expression.contains('(-)') ||
              expression.contains('(x)') ||
              expression.contains('(÷)')) {
            widget.result.value = 'Invalid parentheses';
            return;
          }

          // Replace symbols for actual calculation
          expression = expression.replaceAll('x', '*').replaceAll('÷', '/');

          // Placeholder for future evaluation logic
          widget.result.value = '...';
          return;
        }

        // Append normal input to the text field
        widget.controller.text += value;
        print(widget.controller.text);
      }
      return Expanded(
        flex: 12,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
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
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color(button),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => onButtonPressed(button),
                child: Text(
                  button,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
