import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              height: 200.0,
              width: 200.0,
              child: LoadingIndicator(
                indicatorType: Indicator.ballGridPulse,
                color: Colors.indigo[200],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
