import 'package:connectivity/connectivity.dart';

class InternetConnectivity{

    Future<bool> checkConnection() async{
      var checkConnectivity= await (Connectivity().checkConnectivity());

      if(checkConnectivity==ConnectivityResult.none)
        {
          return false;
        }
      else{
        return true;
      }
    }
}