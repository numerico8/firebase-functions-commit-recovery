import 'package:flutter/material.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/viewmodels/herramientas_viewmodel.dart';
import 'package:pimpineo_v1/widgets/checkout_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pimpineo_v1/services/size_config.dart';




class HerramientasUI extends StatefulWidget {
  @override
  _HerramientasUIState createState() => _HerramientasUIState();
}



class _HerramientasUIState extends State<HerramientasUI> {

  bool editionToggle = false;
  double listHeightRate = 0.15;
  String savedEmail = '********************';
  

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) =>
        ViewModelProvider<HerramientasVM>.withConsumer(
          viewModel: HerramientasVM(),
          onModelReady: (model){
            model.getPaymentMethodsList(user);
            model.getSavedLogInEmail();
          },
          builder: (context,model,child) => SafeArea(
           child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text(//configuracion
                  'Configuracion',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontFamily: 'Poppins',
                    fontSize: SizeConfig.resizeHeight(22)
                  )
               ),
              leading: IconButton( // boton de atras
                  icon: Padding(
                    padding: EdgeInsets.only(left:5.0),
                    child: Icon(Icons.arrow_back_ios, size: SizeConfig.resizeHeight(30), color: Colors.blue[800],),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container( //Metodos de pago text
                    alignment: Alignment.centerLeft,
                    color: Colors.grey[200],
                    height: SizeConfig.resizeHeight(50), 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                      child: Text(
                        'Metodos de Pago Salvados: ',
                        style: TextStyle(
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.resizeHeight(18)
                        )
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(  //listado de las tarjetas de credito
                      padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                      child: ListView.builder(
                        shrinkWrap: true, 
                        itemCount: model.paymentMethods.length,
                        itemBuilder: (context,index){
                          return ExpansionTile(
                            backgroundColor: Colors.white,
                            title: model.paymentMethods[index],
                            trailing: FlatButton.icon(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              highlightColor: Colors.red[50],
                              splashColor: Colors.transparent,
                              onPressed: (){
                                showDialog(context: context, builder: (context){
                                  return CustomAlertDialogs(
                                    selection: 13,
                                    text: 'Para borrar mantenga el boton presionado.',
                                  );
                                });
                              },
                              onLongPress: () async {
                                bool result;
                                result = await model.deletePaymentMethod(user,index);
                                print(result.toString() + ' Transacciones UI'); 
                                if(result){
                                  setState(() {
                                    model.getPaymentMethodsList(user);
                                  });
                                  customAlert(context);
                                }
                                else{showDialog(context: context, builder: (context) => CustomAlertDialogs(selection: 13,text: 'Ocurrio un error borrando el metodo de pago.',));}
                              }, 
                              icon: Icon(Icons.delete_sweep, color: Colors.red[400],), 
                              label: Container(),
                            ),
                          );
                        })
                    ),
                  ),
                   
                  Container( //Eliminar correo salvado en el login
                    alignment: Alignment.centerLeft,
                    color: Colors.grey[200],
                    height: SizeConfig.resizeHeight(50), 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Eliminar Usuario Salvado: ',
                        style: TextStyle(
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.resizeHeight(18)
                        )
                      ),
                    ),
                  ),
                  Container( //Eliminar correo salvado en el login
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    height: SizeConfig.resizeHeight(50), 
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 0),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.remove_red_eye), onPressed: (){setState(() {
                            savedEmail = model.savedEmail;
                          });},
                          highlightColor: Colors.white,   
                          splashColor: Colors.white,                       
                        ),
                        trailing: FlatButton.icon(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          highlightColor: Colors.red[50],
                          splashColor: Colors.transparent,
                          onPressed: (){
                            showDialog(context: context, builder: (context){
                              return CustomAlertDialogs(
                                selection: 13,
                                text: 'Para borrar mantenga el boton presionado.',
                              );
                            });
                          },
                          onLongPress: () async {
                            bool result;
                            result = await model.deleteSavedLogInEmail();
                            if(result){
                              setState(() {
                                savedEmail = model.savedEmail;
                              });
                              customAlert(context);
                            }
                          }, 
                          icon: Icon(Icons.delete_sweep, color: Colors.red[400],), 
                          label: Container(),
                        ), 
                        title: Text( savedEmail ,
                            style: TextStyle(
                              fontFamily: 'Monserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.resizeHeight(16)
                            )
                          ),
                        ),
                    ),
                   ),
                  
                  SizedBox(height: SizeConfig.resizeHeight(40),),
                  Padding( //divider at the end 1
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Divider(color: Colors.grey[200],thickness: 4.0,),
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(15),),
                  //botones al final de la forma del perfil
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container( // boton cancelar
                        height: SizeConfig.resizeHeight(40),
                        width: SizeConfig.resizeWidth(170),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: FlatButton( //boton cancelar
                          color: Colors.red[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                           child: Icon(Icons.cancel, color: Colors.red[900],)
                        ),
                      ),
                    ],
                  ), 
                  SizedBox(height: SizeConfig.resizeHeight(15),),
                  Padding( //divider at the end 2
                    padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Divider(color: Colors.grey[200],thickness: 4.0,),
                  ),
                  

                ],
              ),
            ),
          )
      ),
        ),
    );
  }


  customAlert(BuildContext context){
    return showGeneralDialog(
      context: context,
      pageBuilder: (context,a1,a2){
        Future.delayed(Duration(seconds: 2),(){Navigator.pop(context);});
        final curvedValue = Curves.bounceIn.transform(a1.value);
        return Transform(
          origin: Offset(1,5),
          transform: Matrix4.translationValues(1.0, curvedValue, 1.0),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check, color:Colors.green,size: 60,),
                  SizedBox(height: 5),
                  Text('Cambio Salvado', style: TextStyle(color: Colors.blue[800],fontFamily: 'Poppins'),)
                ],
              ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      useRootNavigator: true
    );  
  }



}