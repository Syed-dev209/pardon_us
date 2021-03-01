import 'package:flutter/material.dart';
import 'package:pardon_us/components/walk_through_widget.dart';

class WalkThrough extends StatefulWidget {
  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Builder(
            builder: (context) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TabPageSelector(
                      indicatorSize: 11.0,
                      selectedColor: Colors.deepPurple,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          WalkThroughWidget(
                              'Stay Connected with your class through messenger',
                              'images/chat_1.png',
                              1),
                          WalkThroughWidget('Create group meeting virtually',
                              'images/meeting_1.png', 2),
                          WalkThroughWidget(
                              'Assignments are basic requirement for learning of students',
                              'images/assignment_1.png',
                              3),
                          WalkThroughWidget(
                              'Challenge your brain by doing quiz',
                              'images/quiz_img2.png',
                              4),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
