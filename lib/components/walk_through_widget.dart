import 'package:flutter/material.dart';
import 'package:pardon_us/screens/start_screen.dart';
import 'package:pardon_us/screens/login_page.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';

class WalkThroughWidget extends StatelessWidget {
  final String imgPath;
  final String text;
  int index;

  WalkThroughWidget(this.text, this.imgPath, this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Image.asset(imgPath)),
        SizedBox(height: 10.0),
        Text(
          text,
          style: TextStyle(
              fontSize: 21.0,
              color: Colors.indigoAccent,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.3, vertical: 10.0),
          child: OutlineButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            padding: EdgeInsets.symmetric( vertical: 8.0),

            //color: Colors.indigo[200],
            borderSide: BorderSide(
                color: Colors.green, width: 1.0, style: BorderStyle.solid),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.indigo,
                  size: 28.0,
                ),
                // SizedBox(
                //   width: 20.0,
                // ),
                index <= 3
                    ? Text('SKIP',
                        style: TextStyle(
                            fontSize: 19.0, color: Colors.indigo))
                    : Text('Enter',
                        style: TextStyle(
                            fontSize: 17.0, color: Colors.indigo)),
              ],
            ),
            onPressed: () {
              final TabController controller = DefaultTabController.of(context);

              Navigator.push(context, ScaleRoute(page: LoginPage()));
              print('pressed');
            },
          ),
        )
      ],
    );
  }
}
