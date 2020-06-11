
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/viewmodels/terminos_y_condiciones_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pimpineo_v1/services/size_config.dart';



class DrawerTermsAndCond extends StatefulWidget {
  static const String route = 'drawert';
  @override
  _DrawerTermsAndCondState createState() => _DrawerTermsAndCondState();
}

class _DrawerTermsAndCondState extends State<DrawerTermsAndCond> {
  
  String termsAndCond = '';
  String acceptedTermsAndCond = '';

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TermsAndCondVM>.withConsumer(
      viewModel: TermsAndCondVM(),
      onModelReady: (model) async {
        if(termsAndCond== ''){
          termsAndCond = await model.getTermsAndConditions();
          setState(() {
            termsAndCond = termsAndCond;
            acceptedTermsAndCond = Provider.of<User>(context, listen: false).termsAndCond;
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
                   height:SizeConfig.resizeHeight(500),
                   width: SizeConfig.resizeWidth(300),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     border: Border.all(color: Colors.grey[600])
                   ),
                   child: SingleChildScrollView(
                     child: Text(
                       termsAndCond,
                       style: TextStyle(fontFamily: 'Solway'),)),
                 ),
               ),
               ListTile( //acepta terminos y condiciones
                 leading: acceptedTermsAndCond == 'true' ? Icon(Icons.check_box,color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.red,) ,
                 title: Text('Estoy de acuerdo', style: TextStyle(fontFamily: 'Poppins', color:Colors.black)),
                 onTap: (){
                 },
               ),
             ],
           ),
         ),
       ),
    );
  }
}