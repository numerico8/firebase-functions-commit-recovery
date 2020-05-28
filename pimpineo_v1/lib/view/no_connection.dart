import 'package:flutter/material.dart';
import 'package:pimpineo_v1/view/launch_page.dart';



class NoConnection extends StatelessWidget {
  static const route = '/no_connecion';  
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:15.0),
                  child: Center(
                    child: Text(
                      'Su equipo no tiene conexion. Por favor conecte el telefono a una red y reinicie la aplicacion.',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontFamily: 'Poppins',
                        fontSize: 22
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0,),
                Center(
                  child: Padding(//thumb up
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: FlatButton(   //thumb up
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.pushNamed(context, LaunchPage.route);
                          },
                          child: Icon(Icons.thumb_up, color: Colors.white)
                      ),
                    ),
                )
              ],
            ),
            backgroundColor: Colors.white,
      ),
    );    
  }    
  

}