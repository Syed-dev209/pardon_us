import 'package:flutter/material.dart';
import 'package:pardon_us/animation_transition/scale_transition.dart';
import 'package:pardon_us/models/login_methods.dart';
import 'package:pardon_us/models/userDeatils.dart';
import 'package:pardon_us/screens/login_page.dart';
import 'package:provider/provider.dart';

class DrawerItem extends StatefulWidget {

  LogInMethods _login;
  bool isLoggedIn=true;
  DrawerItem();

  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    widget._login= LogInMethods();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              accountName: Text(
                Provider.of<UserDetails>(context).username,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                  fontSize: 20.0

                ),
              ),
              accountEmail: Text(Provider.of<UserDetails>(context).Useremail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(Provider.of<UserDetails>(context).userpicture),

              ),
              decoration: BoxDecoration(color: Color(0xFF303F9F)),
            ),
            decoration: BoxDecoration(color: Color(0xFF303F9F)),
          ),

          // SizedBox(
          //   height: 20.0,
          //   child: Divider(color: Colors.black26,),
          // ),
          ListTile(
            leading: Icon(Icons.forward),
            title: Text('ABOUT',style: TextStyle(
              fontSize: 20.0,
              color: Colors.black45
            ),),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('SETTINGS',style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45
            ),),
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('TERMS AND CONDITIONS',style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45
            ),),
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('LOGOUT',style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45
            ),),
            onTap: ()async{
             widget.isLoggedIn= await widget._login.googleSignOut();
             setState(() {
               if(!widget.isLoggedIn){
                 Navigator.push(context, ScaleRoute(page: LoginPage()));
               }
             });


            },
          ),
        ],
      ),
    );
  }
}
