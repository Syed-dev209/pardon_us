import 'package:flutter/material.dart';


class FoldableOption extends StatefulWidget {
 final IconData icon1,icon2;
 final Function onTap1,onTap2;
 FoldableOption({this.icon1,this.icon2,this.onTap1,this.onTap2});

  @override
  _FoldableOptionState createState() => _FoldableOptionState();
}

class _FoldableOptionState extends State<FoldableOption> with SingleTickerProviderStateMixin {


  Animation<Alignment> firstAnim;
  Animation<Alignment> secondAnim;
  Animation<double> verticalPadding;
  AnimationController controller;
  final duration = Duration(milliseconds: 270);

  Widget getItem(IconData source,Function onTap){
    final size=40.0;
    return GestureDetector(
      child:  Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.all(Radius.circular(30.0))
        ),
        child: Icon(
          source,
          color: Colors.white,
          size: 18,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget buildPrimaryItem(IconData source) {
    final size = 60.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.indigo, blurRadius: verticalPadding.value)
          ]),
      child: Icon(
        source,
        color: Colors.white,
        size: 20,
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);

    final anim = CurvedAnimation(parent: controller, curve: Curves.linear);
    firstAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.topRight).animate(anim);
    secondAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.bottomRight).animate(anim);
    verticalPadding = Tween<double>(begin: 0, end: 26).animate(anim);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 200,
      margin: EdgeInsets.only(right: 2),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context,child){
          return Stack(
            children: <Widget>[
            Align(
              alignment: firstAnim.value,
              child: getItem(widget.icon1,widget.onTap1),
            ),
            Align(
                alignment: secondAnim.value,
                child: Container(
                    padding:
                    EdgeInsets.only(left: 50, top: verticalPadding.value),
                    child: getItem(widget.icon2,widget.onTap2)
                )
            ),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () {
                    controller.isCompleted
                        ? controller.reverse()
                        : controller.forward();
                  },
                  child: buildPrimaryItem(
                      controller.isCompleted || controller.isAnimating
                          ? Icons.close
                          : Icons.add)),
            )
          ],
          );
        },
      ),
    );
  }
}
