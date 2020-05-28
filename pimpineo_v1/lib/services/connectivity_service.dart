

import 'package:connectivity/connectivity.dart';



class ConnectivityService {


  
static Future<bool> isConnected() async {


    final ConnectivityResult _connectivityResult = await Connectivity().checkConnectivity();


    if((_connectivityResult == ConnectivityResult.mobile)||(_connectivityResult == ConnectivityResult.wifi)){
      return true;
    }
    else{
      return false;
    }

  }



}
