import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qrcode/home_screen.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'assets/images/welcome.json', // Replace with your Lottie animation file path
              width: 300,
              height: 300,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 300,
              child: SwipeableButtonView(
                buttonText: 'Slide to Scan Qr Code',
                buttonWidget: Container(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  ),
                ),
                activeColor: Color(0xff013274),
                isFinished: isFinished,
                onWaitingProcess: () {
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      isFinished = true;
                    });
                  });
                },
                onFinish: () async {
                  await Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade, child: QrCode()));

                  //TODO: For reverse ripple effect animation
                  setState(() {
                    isFinished = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
