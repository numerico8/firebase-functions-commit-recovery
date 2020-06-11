import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/services/validator.dart';
import 'package:pimpineo_v1/widgets/radiobutton.dart';
import 'package:pimpineo_v1/services/app_theme.dart';
import 'package:pimpineo_v1/services/size_config.dart';


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
        padding: EdgeInsets.only(right: SizeConfig.resizeWidth(14), left: SizeConfig.resizeWidth(14), top: SizeConfig.resizeHeight(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(              //usuario
              'Usuario:',
              style: TextStyle(
                fontFamily: 'Poppins', 
                fontSize: SizeConfig.resizeHeight(18)
              ),
            ),
            TextFormField(   // correo
              controller: controllerUserEmail,
              obscureText: hayEmailSalvado == false ? false : true,
              onTap: onTapUser,
              validator: _validator.validateEmailLogIn,
              style: TextStyle(fontFamily: 'Poppins'),
              onChanged: tapusuariocallback,
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: SizeConfig.resizeHeight(12)),
                hintText: 'correo electronico',
                hintStyle: TextStyle(color: Colors.grey, fontSize: AppTheme.formLetterSize12.fontSize,fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(height: SizeConfig.resizeHeight(10)),
            Text(              //contrasena
              'Contrasena:',
              style:TextStyle(
                fontFamily: 'Poppins', 
                fontSize: SizeConfig.resizeHeight(18)
              ),
            ),
            TextFormField(    //contrasena textformfield
              validator: _validator.validatePasswordLogIn,
              style: TextStyle(fontFamily: 'Poppins'),
              onTap: onTapCS,
              onChanged: tapcontrasenacallback,
              obscureText: true,
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: SizeConfig.resizeHeight(12)),
                hintText: 'contrasena',
                hintStyle: TextStyle(color: Colors.grey, fontSize: SizeConfig.resizeHeight(12), fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(height: SizeConfig.resizeHeight(10)),
            GestureDetector(   //olvido contrasena
              onTap: olvidoContrasena,
              child: Row(  
                mainAxisAlignment: MainAxisAlignment.end,              
                children: <Widget>[
                  SizedBox(height: SizeConfig.resizeHeight(5)),
                  Text(
                    'Olvido su contrasena?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 2,
                      color: Colors.blue,
                      fontFamily: 'Poppins',
                      fontSize: SizeConfig.resizeHeight(14),
                    ),
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(5)),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.resizeHeight(5)),
            GestureDetector(  //recordar contrasena
              onTap: radiocallback,
              child: Row(              
                children: <Widget>[
                  radioButton(isSelected),
                  SizedBox(width: SizeConfig.resizeWidth(10)),
                  Text(
                    'Recordar Usuario',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: SizeConfig.resizeHeight(12)),
                  )
                ],
              ),
            ),
            SizedBox(height: SizeConfig.resizeHeight(15)),
            GestureDetector(              //button entrar              
              onTap: tapentrarcallback,
              child: Center(
                child: Container(
                  width: SizeConfig.resizeWidth(200),
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: SizeConfig.resizeHeight(3)),
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: SizeConfig.resizeHeight(20)),
                  ),
                      )),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[600], Colors.blue[900]]),
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
            Row(              //registrarse
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Nuevo usuario?',
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: SizeConfig.resizeHeight(16)),
                ),
                FlatButton( //boton de registrarse
                  onPressed: tapregistrarsecallback,
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 2,
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                        fontSize: SizeConfig.resizeHeight(16)),
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
