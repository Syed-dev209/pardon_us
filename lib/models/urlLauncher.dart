import 'package:url_launcher/url_launcher.dart';

class Launcher{
  Future<void> launchUrl(String path)async
  {
      if(await canLaunch(path))
        {
          await launch(path);
        }
      else{
        throw "Can not launch Url";
      }
  }
}