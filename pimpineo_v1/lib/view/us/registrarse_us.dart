import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/formatter.dart';
import 'package:pimpineo_v1/services/validator.dart';
import 'package:pimpineo_v1/services/viewstate.dart';
import 'package:pimpineo_v1/view/base_view.dart';
import 'package:pimpineo_v1/view/login.dart';
import 'package:pimpineo_v1/view/us/us_lobby.dart';
import 'package:pimpineo_v1/viewmodels/registrarse_us_view_model.dart';
import 'package:pimpineo_v1/services/size_config.dart';




class RegistrarseUS extends StatefulWidget {
  static const String route = '/registrarse_us';

  @override
  _RegistrarseUSState createState() => _RegistrarseUSState();
}

class _RegistrarseUSState extends State<RegistrarseUS> {
  
  //variables locales to create the user repo
  String _nombre;
  String _correo;
  String _contrasena;  
  String _telefono;
  var _credito = 0;
  String pais = 'us';

  //key to be used to validate the form
  final _formKey = GlobalKey<FormState>();

  //validation service
  UserValidator _validator = UserValidator();

  //agreed terms and conditions
  bool agreeTermsAndConditions = false;

  //Main container box height
  double boxHeight = SizeConfig.resizeHeight(500);
  
  @override
  Widget build(BuildContext context) {
    return BaseView<RegistrarseViewModel>(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton( //button to go back
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                model.setState(ViewState.Idel);
                Navigator.pushNamedAndRemoveUntil(context, LogIn.route ,  (Route<dynamic> route) => false);
              },
              color: Colors.blue[800],
              iconSize: SizeConfig.resizeHeight(28),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            title: Padding(
              padding: EdgeInsets.only(right: SizeConfig.resizeHeight(60)),
              child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Container(
                     padding: EdgeInsets.only(top: 5.0),
                     height: SizeConfig.resizeHeight(50),
                     width: SizeConfig.resizeHeight(50),
                     child: Image.asset('images/us.png')),
                 SizedBox(width: 5.0),
                 Text( //Pimpineo logo
                   'Pimpineo',
                   style: TextStyle(
                       color: Colors.blue[800],
                       fontFamily: 'Pacifico',
                       fontSize: SizeConfig.resizeHeight(30)),
                 ),
                 ],
           ),
            ),
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          resizeToAvoidBottomInset: true,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(   //white background two expanded containers
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              SingleChildScrollView(  //elevated box with all the information for the user to register
                child: Padding(
                padding: EdgeInsets.only(left: SizeConfig.resizeWidth(20), right: SizeConfig.resizeWidth(20), top: SizeConfig.resizeHeight(15)),
                child: Container(
                  padding: EdgeInsets.only(right: SizeConfig.resizeWidth(14), left: SizeConfig.resizeWidth(14), top: SizeConfig.resizeHeight(10)),
                  width: double.infinity,
                  decoration: BoxDecoration( //box shadow with the registration form
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
                  child: model.state == ViewState.Busy
                  ? Container(
                    width: double.infinity,
                    height: boxHeight,
                    child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Stack(
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                            radius: 38,
                            backgroundColor: Colors.blue[800],
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                'P',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Pacifico',
                                  fontSize: 38
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(
                              strokeWidth: 5,
                              valueColor: AlwaysStoppedAnimation(Colors.blue[800]),
                              backgroundColor: Colors.white,
                        ),
                          ),)
                      ],
                     ),
                    )),
                  ) 
                  : Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(//nombre
                          keyboardType: TextInputType.text,
                          validator: _validator.validateName,
                          style: TextStyle(fontFamily: 'Poppins'),
                          onChanged: (value){
                            this._nombre = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Nombre',
                            hintStyle:
                                TextStyle(color: Colors.grey,fontFamily: 'Poppins', fontSize: SizeConfig.resizeHeight(12)),
                          ),
                        ),
                        TextFormField(//contrasena
                          onChanged: (val){
                            this._contrasena = val;
                          },
                          keyboardType: TextInputType.text,
                          validator: _validator.validatePassword,
                          style: TextStyle(fontFamily: 'Poppins'),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Contrasena',
                            hintStyle:
                                TextStyle(color: Colors.grey,fontFamily: 'Poppins', fontSize: SizeConfig.resizeHeight(12)),
                          ),
                        ),
                        TextFormField(//confirmar contrasena
                          keyboardType: TextInputType.text,
                          validator: _validator.validateConfirmPassword,
                          style: TextStyle(fontFamily: 'Poppins'),
                          onChanged: (val) {
                          }, // tapcontrasenacallback,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirmar Contrasena',
                            hintStyle:
                                TextStyle(color: Colors.grey,fontFamily: 'Poppins', fontSize: SizeConfig.resizeHeight(12)),
                          ),
                        ),
                        TextFormField(//telefono 
                          initialValue: '+1-',
                          keyboardType: TextInputType.phone,
                          validator: _validator.validatePhoneUS,
                          style: TextStyle(fontFamily: 'Poppins'),
                          onChanged: (val) {
                            this._telefono = val; // if for some reson I would like to clean the saved phoen number a.replaceAll('+', '').replaceAll('-', '');
                          }, // tapcontrasenacallback,
                          decoration: InputDecoration(
                            hintText: 'Numero de Telefono(ejemplo):11234567890',
                            hintStyle:
                                TextStyle(color: Colors.grey,fontFamily: 'Poppins', fontSize: SizeConfig.resizeHeight(12)),
                          ),
                          inputFormatters: [ //mask that creates the dashes
                            TextFormatter(
                              separator: '-',
                              mask: '+1-xxx-xxx-xxxx'
                            )
                          ],
                        ),
                        TextFormField(//correo electronico
                          keyboardType: TextInputType.emailAddress,
                          validator: _validator.validateEmail,
                          style: TextStyle(fontFamily: 'Poppins'),
                          onChanged: (val) {
                            this._correo = val;
                          }, // tapcontrasenacallback,
                          decoration: InputDecoration(
                            hintText: 'Correo Electronico(ejemplo):correo@email.com',
                            hintStyle:
                                TextStyle(color: Colors.grey,fontFamily: 'Poppins', fontSize: SizeConfig.resizeHeight(12)),
                          ),
                        ),
                        SizedBox(height: SizeConfig.resizeHeight(20),),
                        FlatButton( //button registrar
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          onPressed: () async {
                           if(_formKey.currentState.validate()){
                             var _result = await model.registerUserButton(context,this._correo, this._contrasena, this._nombre, this.pais, this._telefono, this._credito);
                             if(_result.contains('registrado')){ //la palabra registrado no viene del modelo sino del authenticationservice
                               Navigator.pushNamedAndRemoveUntil(context, LobbyUS.route,  (Route<dynamic> route) => false);
                             }
                             else{
                               showDialog( 
                                 context: context,
                                 builder: (context){
                                   return customAlertError(
                                     text: _result,
                                   ); 
                                });
                             }
                           } 
                          },
                          child: Center(
                            child: Container(
                              width: SizeConfig.resizeWidth(200),
                              height: SizeConfig.resizeHeight(40),
                              child: Center(
                                  child: Text(
                                'Registrarse',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: SizeConfig.resizeHeight(20)),
                              )),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.blue[600],
                                    Colors.blue[900]
                                  ]),
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.resizeHeight(5),),
                        FlatButton( //button registrar con google
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          onPressed: () async {
                            String result;
                            result = await model.registrarseConGoogle(context);
                            if(result.contains('registrado')){
                              showDialog(barrierDismissible: false,context: context,builder: (context) =>  customAlert(text: 'Revise la bandeja de entrada de su correo GMAIL, click el enlace y cree su contrasena Pimpineo.',));
                            }else{
                              showDialog( 
                                 context: context,
                                 builder: (context){
                                  return customAlertError(
                                    text: result,
                                  ); 
                              });
                            }
                          },
                          child: Center(
                            child: Container(
                              width: SizeConfig.resizeWidth(200),
                              height: SizeConfig.resizeHeight(40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset('images/google3.png'),
                                  SizedBox(width:2),
                                  Text(
                                    ' para registrarse',
                                    style: TextStyle(
                                            color: Colors.grey[800],
                                            fontFamily: 'Solway',
                                            fontSize: SizeConfig.resizeHeight(16)),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300],width: 3),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0)
                                ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.resizeHeight(15),), 
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        )
      ),
    );
  }


  Widget customAlert({String text}){
    return AlertDialog(
          contentPadding: EdgeInsets.only(bottom: 10,left: 20,right: 20, top: 20,),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: FittedBox(
            child: Container(
              height: SizeConfig.resizeHeight(MediaQuery.of(context).size.height * 0.30),
              width: SizeConfig.resizeWidth(300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(text,style: TextStyle(fontFamily: 'Poppins',fontSize: SizeConfig.resizeHeight(16)),),
                  SizedBox(height: SizeConfig.resizeHeight(20)),
                  Center(
                    child: FlatButton(   //thumb up
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.green,
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, LobbyUS.route,  (Route<dynamic> route) => false);
                        },
                        child: Icon(Icons.thumb_up, color: Colors.white,size: SizeConfig.resizeHeight(25),)
                    ),
                  ),
               ],
              ),
            ),
          ),
        );
  }


  Widget customAlertError({String text}){
    return AlertDialog(
          contentPadding: EdgeInsets.only(bottom: 10,left: 20,right: 20, top: 20,),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: FittedBox(
            child: Container(
              height: SizeConfig.resizeHeight(MediaQuery.of(context).size.height * 0.30),
              width: SizeConfig.resizeWidth(300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(text,style: TextStyle(fontFamily: 'Poppins',fontSize: SizeConfig.resizeHeight(16)),),
                  SizedBox(height: SizeConfig.resizeHeight(20)),
                  Center(
                    child: FlatButton(   //thumb up
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.green,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.thumb_up, color: Colors.white,size: SizeConfig.resizeHeight(25),)
                    ),
                  ),
               ],
              ),
            ),
          ),
        );
  }



}




