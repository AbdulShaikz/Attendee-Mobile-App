import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HelloWorld extends StatefulWidget {
  @override
  _HelloWorldState createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    //TODO: implement initState
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    animationController.repeat(reverse: true);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ShaderMask(
          child: Text(
            "Hello Worldddddddddddddddddd",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          shaderCallback: (rect) {
            return LinearGradient(stops: [
              animation.value - 0.5,
              animation.value,
              animation.value + 0.5
            ], colors: [
              Colors.orange,
              Colors.white,
              Colors.green
            ]).createShader(rect);
          },
        ),
      ),
    );
  }
}
