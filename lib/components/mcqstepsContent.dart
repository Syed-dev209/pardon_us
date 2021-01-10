import 'package:flutter/material.dart';
import 'package:pardon_us/models/create_Mcqs_Model.dart';
import 'package:provider/provider.dart';

class StepContent extends StatefulWidget {
  int radioval=0;
  String question;
  String opt1,opt2,opt3;
  int currentIndex;

  StepContent(this.question,this.opt1,this.opt2,this.opt3,this.currentIndex);
  @override
  _StepContentState createState() => _StepContentState();
}

class _StepContentState extends State<StepContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<QuizModel>(context,listen: false).setSelAns(widget.opt1, widget.currentIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.question,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        Column(
          children: [
            Row(
              children: [
                Radio(value: 0,
                    groupValue: widget.radioval,
                    onChanged: (value){
                      setState(() {
                        widget.radioval=value;
                        Provider.of<QuizModel>(context,listen: false).setSelAns(widget.opt1, widget.currentIndex);
                      });
                    }),
                Text(widget.opt1)
              ],
            ),
            Row(
              children: [
                Radio(value: 1,
                    groupValue: widget.radioval,
                    onChanged: (value){
                      setState(() {
                        widget.radioval=value;
                        Provider.of<QuizModel>(context,listen: false).setSelAns(widget.opt2, widget.currentIndex);
                      });
                    }),
                Text(widget.opt2)
              ],
            ),
            Row(
              children: [
                Radio(value: 2,
                    groupValue: widget.radioval,
                    onChanged: (value){
                      setState(() {
                        widget.radioval=value;
                        Provider.of<QuizModel>(context,listen: false).setSelAns(widget.opt3, widget.currentIndex);
                      });
                    }),
                Text(widget.opt3)
              ],
            ),
          ],
        )
      ],
    );
  }
}
