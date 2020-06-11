import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:pimpineo_v1/view/us/registrarse_us.dart';
import 'package:pimpineo_v1/viewmodels/terminos_y_condiciones_viewmodel.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pimpineo_v1/services/size_config.dart';


class TermsAndCond extends StatefulWidget {
  static const String route = 'termsandcond';
  @override
  _TermsAndCondState createState() => _TermsAndCondState();
}

class _TermsAndCondState extends State<TermsAndCond> {

  bool agreeTermsAndCond;
  ScrollController controller = new ScrollController();
  String termsAndCond = '';

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TermsAndCondVM>.withConsumer(
      viewModel: TermsAndCondVM(),
      onModelReady: (model) async {  //inteligencia inicial para tomar los terminos y las condiciones de la nube por si es necesarion cambiarlo
        Helpers.agreeTermsAndCond = false;
        agreeTermsAndCond = Helpers.agreeTermsAndCond;
        if(termsAndCond == ''){
          String result = await model.getTermsAndConditions();
          setState((){
            termsAndCond = result;           
          });
        }
      },
      builder: (context, model,child) => SafeArea(
         child: Scaffold(    
           appBar: AppBar(
             elevation: 0,
             centerTitle: true,
             backgroundColor: Colors.white,
             title: Text(//Mi Perfil
                 'Terminos y Condiciones',
                 style: TextStyle(
                     color: Colors.blue[800],
                     fontFamily: 'Poppins',
                     fontSize: SizeConfig.resizeHeight(22))),
             leading: IconButton(  // boton de atras
               icon: Padding(
                 padding: EdgeInsets.only(left: 5.0),
                 child: Icon(
                   Icons.arrow_back_ios,
                   size: SizeConfig.resizeHeight(30),
                   color: Colors.blue[800],
                 ),
               ),
               onPressed: () {
                 Navigator.pop(context);
               },
             ),
           ),
           body: ListView(
             children: <Widget>[
               Padding( // terminos y condiciones
                 padding: const EdgeInsets.only(top: 12.0,right: 12,left: 12,),
                 child: Container( // terminos y condiciones
                   padding: EdgeInsets.all(5),
                   height:SizeConfig.resizeHeight(450),
                   width: SizeConfig.resizeWidth(300),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     border: Border.all(color: Colors.grey[600])
                   ),
                   child: SingleChildScrollView(
                     controller: controller,
                     child: Text(
                       termsAndCond,
                       style: TextStyle(fontFamily: 'Solway'),)),
                 ),
               ),
               ListTile( //acepta terminos y condiciones
                 leading: !agreeTermsAndCond ? Icon(Icons.check_box_outline_blank,color: Colors.red,) : Icon(Icons.check_box,color: Colors.green,),
                 title: Text('Estoy de acuerdo', style: TextStyle(fontFamily: 'Poppins', color:agreeTermsAndCond ? Colors.black : Colors.grey[600])),
                 onTap: (){
                     setState(() {
                       agreeTermsAndCond = !agreeTermsAndCond;
                     });
                 },
               ),
               Center( // registrarse
                  child: FlatButton(   // registrarse
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: agreeTermsAndCond ? Colors.green : Colors.grey[400],
                      onPressed: () {
                        if(!(termsAndCond == '')){
                          if(agreeTermsAndCond){
                            Navigator.pushNamedAndRemoveUntil(context, RegistrarseUS.route ,  (Route<dynamic> route) => false);
                            Helpers.agreeTermsAndCond = true;
                          }
                        }
                      },
                      child: Text('Registrarse', style: TextStyle(fontFamily: 'Poppins',color: Colors.white, fontSize: SizeConfig.resizeHeight(20)),)
                  ),
                ),
             ],
           ),
         ),
       ),
    );
   }


}