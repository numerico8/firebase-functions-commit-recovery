import 'package:flutter/material.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/viewmodels/herramientas_viewmodel.dart';
import 'package:pimpineo_v1/widgets/checkout_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/provider_architecture.dart';




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
              title: Text(//Mi Perfil
                  'Configuracion',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontFamily: 'Poppins',
                    fontSize: 22.0
                  )
               ),
              leading: IconButton( // boton de atras
                  icon: Padding(
                    padding: EdgeInsets.only(left:5.0),
                    child: Icon(Icons.arrow_back_ios, size: 30.0, color: Colors.blue[800],),
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
                    height: 50.0, 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                      child: Text(
                        'Metodos de Pago Salvados: ',
                        style: TextStyle(
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0
                        )
                      ),
                    ),
                  ),
                  Container( //Metodos de pago list
                    height: MediaQuery.of(context).size.height * listHeightRate, //asi es como se recoge la lista dentro del container
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                      child: ListView.builder(
                        shrinkWrap: true, 
                        itemCount: model.paymentMethods.length,
                        itemBuilder: (context,index){
                          return ListTile(
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
                    height: 50.0, 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Eliminar Usuario Salvado: ',
                        style: TextStyle(
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0
                        )
                      ),
                    ),
                  ),
                  Container( //Eliminar correo salvado en el login
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    height: 50.0, 
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
                            }
                          }, 
                          icon: Icon(Icons.delete_sweep, color: Colors.red[400],), 
                          label: Container(),
                        ), 
                        title: Text( savedEmail ,
                            style: TextStyle(
                              fontFamily: 'Monserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0
                            )
                          ),
                        ),
                    ),
                   ),
                  
                  SizedBox(height: 40.0,),
                  Padding( //divider at the end 1
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Divider(color: Colors.grey[200],thickness: 4.0,),
                  ),
                  SizedBox(height: 15.0,),
                  //botones al final de la forma del perfil
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container( // boton cancelar
                        height: 40.0,
                        width: 170.0,
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
                  SizedBox(height: 15.0,),
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

}