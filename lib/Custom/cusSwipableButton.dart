import 'package:flutter/material.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

bool isFinished = false;

Widget cusSwipeableButton(BuildContext context,fun(),String btnText,bool isDialog) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: SwipeableButtonView(
          onFinish: () async {
            if(!isDialog) {
              Navigator.pushNamedAndRemoveUntil(
                context, 'home', (route) => false,);
            }
            setState((){
              isFinished = false;
            });
          },
          onWaitingProcess: () {
            Future.delayed(Duration(milliseconds: 200),(){
              setState((){
                fun();
                isFinished = true;
              });
            });
          },
          activeColor: Colors.grey,
          isFinished: isFinished,
          buttonWidget: const Icon(Icons.double_arrow_rounded,color: Colors.black,),
          buttonText: btnText,
        ),
      );
    }
  );
}
