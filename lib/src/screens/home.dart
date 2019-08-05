import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    setupCatAnimation();

    setupBoxAnimation();
  }

  setupBoxAnimation() {
    boxController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    boxAnimation = Tween(begin: 0.0, end: pi * 0.01).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.linear,
      ),
    );

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });

    boxController.forward();
  }

  setupCatAnimation() {
    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -35.0, end: -80.0).animate(CurvedAnimation(
      parent: catController,
      curve: Curves.easeIn,
    ));
  }

  animate() {
    if (catController.isDismissed) {
      catController.forward();
      boxController.stop();
    } else if (catController.isCompleted) {
      catController.reverse();
      boxController.forward();
    }
  }

  onTap() {
    animate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation !'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      child: Cat(),
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0,
          left: 0,
        );
      },
    );
  }

  Widget buildBox() {
    return Container(
      width: 200.0,
      height: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildFlap(bool left) {
    return AnimatedBuilder(
      animation: boxAnimation,
      child: Flap(left: left),
      builder: (context, child) {
        return Transform.rotate(
          angle: left ? boxAnimation.value : -boxAnimation.value,
          alignment: left ? Alignment.topLeft : Alignment.topRight,
          child: child,
        );
      },
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      top: 1.0,
      child: buildFlap(true),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      top: 1.0,
      child: buildFlap(false),
    );
  }
}

class Flap extends StatelessWidget {
  final bool left;

  Flap({this.left = true});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: left ? pi * 0.6 : -pi * 0.6,
      alignment: left ? Alignment.topLeft : Alignment.topRight,
      child: Container(
        width: 125.0,
        height: 10.0,
        color: Colors.red,
      ),
    );
  }
}
