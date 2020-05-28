import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/services/validator.dart';
import 'package:pimpineo_v1/widgets/radiobutton.dart';

class MyFormCard extends StatelessWidget {
  final Function olvidoContrasena;
  final Function radiocallback;
  final bool isSelected;
  final void Function(String) tapusuariocallback;
  final void Function(String) tapcontrasenacallback;
  final Function tapolvidocallback;
  final Function tapentrarcallback;
  final Function tapregistrarsecallback;
  final Function onTapUser;
  final Function onTapCS;

  final UserValidator _validator = locator<UserValidator>();
  
  MyFormCard(
      {Key key,
      this.olvidoContrasena,
      this.radiocallback,
      this.isSelected,
      this.tapusuariocallback,
      this.tapcontrasenacallback,
      this.tapolvidocallback,
      this.tapentrarcallback,
      this.tapregistrarsecallback, 
      this.onTapUser, 
      this.onTapCS,})
      : super(key: key);
  
  static TextEditingController controllerUserEmail = new TextEditingController();
  static bool hayEmailSalvado;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 380.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 15.0)
          ]),
      child: Padding(
        padding: EdgeInsets.only(right: 14.0, left: 14.0, top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(              //usuario
              'Usuario:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18.0),
            ),
            TextFormField(   // correo
              controller: controllerUserEmail,
              obscureText: hayEmailSalvado == false ? false : true,
              onTap: onTapUser,
              validator: _validator.validateEmailLogIn,
              style: TextStyle(fontFamily: 'Poppins'),
              onChanged: tapusuariocallback,
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 12),
                hintText: 'correo electronico',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0,fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(height: 10.0),
            Text(              //contrasena
              'Contrasena:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18.0),
            ),
            TextFormField(    //contrasena textformfield
              validator: _validator.validatePasswordLogIn,
              style: TextStyle(fontFamily: 'Poppins'),
              onTap: onTapCS,
              onChanged: tapcontrasenacallback,
              obscureText: true,
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 12),
                hintText: 'contrasena',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0, fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(height: 10.0,),
            GestureDetector(   //olvido contrasena
              onTap: olvidoContrasena,
              child: Row(             
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: tapolvidocallback,
                    child: Text(
                      'Olvido su contrasena?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 2,
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5.0),
            Row(              //recordar contrasena
              children: <Widget>[
                GestureDetector(
                  onTap: radiocallback,
                  child: radioButton(isSelected),
                ),
                SizedBox(width: 10.0),
                Text(
                  'Recordar Usuario',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12.0),
                )
              ],
            ),
            SizedBox(height: 15.0, ),
            InkWell(              //button entrar
              onTap: tapentrarcallback,
              child: Center(
                child: Container(
                  width: 200,
                  height: 40,
                  child: Center(
                      child: Text(
                    'Entrar',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 20.0),
                  )),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blue[600], Colors.blue[900]]),
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(              //registrarse
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Nuevo usuario?',
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: 16.0),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: tapregistrarsecallback,
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 2,
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                        fontSize: 16.0),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
