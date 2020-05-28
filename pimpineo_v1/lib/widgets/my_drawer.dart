import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/animation_service.dart';
import 'package:pimpineo_v1/view/login.dart';
import 'package:pimpineo_v1/view/us/herramientas.dart';
import 'package:pimpineo_v1/view/us/profile_page.dart';
import 'package:pimpineo_v1/viewmodels/us_lobby_model.dart';
import 'package:provider/provider.dart';


class MyDrawer extends StatefulWidget {
  final USLobbyModel model;
  const MyDrawer({this.model}); 
  @override
  _MyDrawerState createState() => _MyDrawerState();
}


class _MyDrawerState extends State<MyDrawer> {
  
  AnimationService animation = locator<AnimationService>();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          children: <Widget>[
            Padding( //lista del drawer
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container( //Profile avatar que va a ser un circulo con la inicial del ususario en este y abajo el numero de telefono del usuario
                    width: 260, 
                    height: 170, 
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue[800],
                          width: 2.0,
                          style: BorderStyle.solid
                        )
                      )
                    ),
                    child: Column(//circle avatar and name
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar( //circle avatar with the initial
                          backgroundColor: Colors.white,
                          radius: 40.0,
                          child: Image.asset('images/us.png'),
                        ),
                        SizedBox(height: 10.0),
                        Text(  //name in the list 
                            Provider.of<User>(context).nombre.split(' ')[0].toUpperCase(),
                            style:TextStyle(
                              color: Colors.grey[600],
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w500
                            )
                          ),                      
                      ],
                    ),
                  ),
                  Container( //el perfil entero del usuario y si por alguna calualidad este quiere cambiaqr algo 
                    width: 260, 
                    height: 60, 
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:  Colors.blue[800],
                          width: 2.0,
                          style: BorderStyle.solid
                        )
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: FlatButton(
                        splashColor: Colors.white,
                        onPressed: (){ Navigator.of(context).push(animation.createRoute(ProfilePage()));},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[ //mi perfil
                            Text(
                                'Mi Perfil',
                                style:TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                )
                            ), 
                            SizedBox(width:10.0),
                            Icon(Icons.arrow_forward_ios,color: Colors.grey[600], size: 20.0,)
                          ],
                        ),
                      ),
                    )
                  ),
                  Container( //Configuracion
                    width: 260, 
                    height: 60, 
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:  Colors.blue[800],
                          width: 2.0,
                          style: BorderStyle.solid
                        )
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: FlatButton(
                        onPressed: (){
                         Navigator.of(context).push(animation.createRoute(HerramientasUI()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[ //mi perfil
                            Text(
                                'Configuracion',
                                style:TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                  fontSize:16,
                                  fontWeight: FontWeight.w500
                                )
                            ), 
                            SizedBox(width:10.0),
                            Icon(Icons.build ,color: Colors.grey[600], size: 20.0,)
                          ],
                        ),
                      ),
                    )
                  ),
                  Container( //Contactarnos
                    width: 260, 
                    height:60,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:  Colors.blue[800],
                          width: 2.0,
                          style: BorderStyle.solid
                        )
                      )
                    ),
                    child: FlatButton(
                      onPressed: (){},
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[ //mi perfil
                            Text(
                                'Contactanos',
                                style:TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                  fontSize:16,
                                  fontWeight: FontWeight.w500
                                )
                            ), 
                            SizedBox(width:10.0),
                            Icon(Icons.perm_phone_msg ,color: Colors.grey[600], size: 20.0,)
                          ],
                        ),
                      ),
                    )
                  ),
                  Container( //Terminos y condiciones
                    width: 260, 
                    height:60,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:  Colors.blue[800],
                          width: 2.0,
                          style: BorderStyle.solid
                        )
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: FlatButton(
                        onPressed: (){},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[ //mi perfil
                            Text(
                                'Terminos y Condiciones',
                                style:TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                )
                            ), 
                            SizedBox(width:0.0),
                            Icon(FontAwesomeIcons.graduationCap ,color: Colors.grey[600], size: 20.0,)
                          ],
                        ),
                      ),
                    )
                  ),
                  Container( //Salir de la aplication 
                    width: 260, 
                    height:60, 
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: FlatButton(
                        onPressed: (){
                          widget.model.logout();
                          Navigator.pushNamedAndRemoveUntil(context, LogIn.route,  (Route<dynamic> route) => false);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[ //mi perfil
                            Text(
                                'Salir',
                                style:TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                  fontSize:16,
                                  fontWeight: FontWeight.w500
                                )
                            ), 
                            SizedBox(width:10.0),
                            Icon(Icons.power_settings_new ,color: Colors.grey[600], size: 20.0,)
                          ],
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
