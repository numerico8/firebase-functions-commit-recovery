import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pimpineo_v1/services/size_config.dart';



class ContactUS extends StatefulWidget {
  static const String route = 'contact_us';
  @override
  _ContactUSState createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {
  final String url = 'https://forms.gle/AZa5cKKypR7P7upN6';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
         child: Scaffold(    
           appBar: AppBar(
             elevation: 0,
             centerTitle: true,
             backgroundColor: Colors.white,
             title: Text(//Mi Perfil
                 'Contactanos',
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
           body: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: <Widget>[
               SizedBox(height: SizeConfig.resizeHeight(10),),
               Padding( //palabreria de contactarnos
                 padding: const EdgeInsets.all(12.0),
                 child: Text('Para contactarnos complete la forma a cotinuacion. Le daremos respuesta en un plazo de 24 horas.\nDe antemano agradecemos su paciencia y aseguramos que cualquiera sea su situacion haremos todo lo que este a nuestro alcance para ayudarl@.\n\nMuchas Gracias!!\nEquipo de Pimpineo',
                 style: TextStyle(fontFamily: 'Solway', fontSize: SizeConfig.resizeHeight(18)),
                 ),
               ),
               SizedBox(height: SizeConfig.resizeHeight(50),),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 child: FlatButton(
                   padding: EdgeInsets.all(5),
                   onPressed: () async {
                     if(await canLaunch(url)){
                       launch(url);
                     }                     
                   }, 
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                   color: Colors.blue[800],
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Icon(Icons.contact_phone,color: Colors.white,),
                       SizedBox(width:SizeConfig.resizeHeight(10)),
                       Text('Contactar',style: TextStyle(fontFamily: 'Poppins',color: Colors.white, fontSize: SizeConfig.resizeHeight(20)))
                     ],)
              ),
               )
             ],
           ),
      ),
    );
   }


}