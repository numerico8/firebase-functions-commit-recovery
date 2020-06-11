import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/services/validator.dart';
import 'package:pimpineo_v1/services/viewstate.dart';
import 'package:pimpineo_v1/view/us/terminos_y_condiciones.dart';
import 'package:pimpineo_v1/viewmodels/login_viewmodel.dart';
import 'package:pimpineo_v1/widgets/log_in_form.dart';
import 'package:pimpineo_v1/widgets/checkout_dialogs.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pimpineo_v1/services/app_theme.dart';
import 'package:pimpineo_v1/services/size_config.dart';


class LogIn extends StatefulWidget {
  static const String route = '/log_in';
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  
  
  //recordar contrasena
  bool _isSelected = false;

  String _email = '';
  String _contrasena;

  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  
  //olvido de contrasena logica
  final UserValidator _validator = locator<UserValidator>();
  bool validarSoloUnCampo = false;

  //imagen del backdrop
  bool allWhite = false;

  //to load the initial email function this variable needs to be false meaning the user textformfield is not tap
  bool isUserFieldTapped = false;
  bool getInitialEmailCall = false;

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.black),
              )
            : Container(),
      );

  
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LogInModel>.withConsumer(
      viewModel: LogInModel(),
      onModelReady: (model){
        if(isUserFieldTapped == false){
         getInitialEmail(model);
        }
      },
      builder: (context, model, child) {
       return SafeArea(
        child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomPadding: true,
              resizeToAvoidBottomInset: true,
              body: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Column(       //background picture
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding( //logo
                        padding: const EdgeInsets.only(top:5.0),
                        child: Center(
                          child: Container(
                            height: 11.7 * SizeConfig.blockSizeVertical,
                            child: Text( //logo
                              'Pimpineo',
                              style: AppTheme.headlineStyle,
                            ),
                          ),
                        ),
                      ),
                      Expanded( //background image
                        child: Image.asset('images/2.png'),
                      ),
                     ],
                  ),
                  SingleChildScrollView(        //elevated box
                    child: Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.resizeWidth(20), right: SizeConfig.resizeWidth(20), top: SizeConfig.resizeHeight(220)),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: SizeConfig.resizeHeight(30)),
                        model.state == ViewState.Busy
                        ? Padding(   //circular porgresss indicator 
                          padding: EdgeInsets.only(top: SizeConfig.resizeHeight(60)),
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
                          ),
                        )
                        : Form(
                            key: _keyForm,
                            child: MyFormCard( //here we add all the callbacks with the controllers
                                olvidoContrasena: () async { //dialogo para reiniciar la contrasena
                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                      actions: <Widget>[
                                        Center( //texto inicial en el dialogo
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Text(
                                              'Se le enviara un correo electronico, por favor revise su bandeja de entrada.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Sen'
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center( //Formfield del correo electronico
                                          child: SizedBox(
                                            height: 50,
                                            width: 280,
                                            child: TextFormField(
                                              autovalidate: validarSoloUnCampo,
                                              validator: _validator.validateEmailLogIn,
                                              onChanged: (val){_email = val;},
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(fontSize: 12),
                                                hintText: 'Entre aqui el correo registrado en la cuenta.',
                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center( //boton de enviar
                                          child: FlatButton(  //enviar
                                            padding: EdgeInsets.symmetric(horizontal: 90),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0)),
                                            color: Colors.green,
                                            onPressed: () async {
                                              setState(() {
                                                validarSoloUnCampo = true;
                                              }); 
                                              String result = await model.olvidoContrasena(_email);
                                              //dialogo de resultado cuando se esta haciendo el envio del correo para reiniciar la contrasena
                                              showDialog(context: context, builder: (context) => CustomAlertDialogs(
                                                selection: 12,
                                                text: result,
                                              ));
                                            },
                                            child: Text(
                                              'Enviar',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins'),
                                            )),
                                        ),
                                      ],
                                    );
                                  });                            
                                },
                                tapentrarcallback: () async { //boton de entrar
                                  if(_keyForm.currentState.validate()){
                                    //it says country because it will check what country user is connecting from
                                    var result = await model.login(_email, _contrasena);
                                    if(!result.contains('Registrarse')){
                                      if(_isSelected){//si el usuario quiere recordar la contrasena
                                        model.saveUserEmail(_email);
                                      }
                                      String route = '/lobby_'+ result;
                                      MyFormCard.controllerUserEmail.clear();
                                      Navigator.pushNamedAndRemoveUntil(context, route, (Route<dynamic> route) => false);
                                    }else{
                                      showDialog( //usuario no existe y te manda a registrarte
                                         context: context,
                                         builder: (context){
                                           return CustomAlertDialogs(selection: 13, text: result,);
                                        });
                                    }
                                  }
                                },
                                tapusuariocallback: (val) async { //user email
                                  this._email = val;
                                  //si esta tapped no carga la funcion que hace que se muestre el ususario salvado como valor inicial de este campo
                                  if(!isUserFieldTapped){
                                    setState(() {
                                      isUserFieldTapped = true;
                                      MyFormCard.hayEmailSalvado = false;                                    
                                    });
                                  }
                                },
                                tapcontrasenacallback: (val){//value in the text field equals local contrasena field
                                    this._contrasena = val;
                                  },
                                tapregistrarsecallback: () { //registration flags
                                  //navigate to register from the us
                                  Navigator.pushNamed(context, TermsAndCond.route);
                                },
                                isSelected: _isSelected,
                                radiocallback: () {
                                    setState(() {
                                     _isSelected = !_isSelected;
                                    });
                                },),
                          )
                      ],
                    ),
                  ))
                ],
              ),
            ),
       );}
    );
  }



  //coge el email de share preferences si el cliente deseo salvar el usuario
  getInitialEmail(LogInModel model) async {
    if(!getInitialEmailCall){
      String result;
      result = await model.getSavedUserEmail();
      if(result != ''){
        setState(() {
          MyFormCard.controllerUserEmail = TextEditingController(text: result);
          MyFormCard.hayEmailSalvado = true;
          getInitialEmailCall = true;
          _email = result;
        });
      }else{
          MyFormCard.hayEmailSalvado = false;
          _email = result;    
      }   
    }
  }


  

}

