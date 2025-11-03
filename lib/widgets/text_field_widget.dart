import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget{
   final TextEditingController controller;
   const TextFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
   return  Expanded( flex: 3, child:
   Container(
     color: Color.fromARGB(255, 58, 58, 58),
     child:TextField(
       controller: controller,
       textAlign: TextAlign.right,
       style: TextStyle(color: Colors.white,fontSize: 35),
       readOnly: true,
       showCursor: true,
       cursorColor: Colors.white,
       expands: true,
       maxLines: null,
       minLines: null,
       decoration: InputDecoration(border: InputBorder.none,
         contentPadding: EdgeInsets.all(16),),

     ),
   ),
   );
  }

}
