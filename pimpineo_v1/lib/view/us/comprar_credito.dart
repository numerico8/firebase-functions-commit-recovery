import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/view/base_view.dart';
import 'package:pimpineo_v1/viewmodels/comprar_credito_model.dart';
import 'package:pimpineo_v1/widgets/checkout_dialogs.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:provider/provider.dart';

class ComprarCreditoUI extends StatefulWidget {
  static const String route = "/comprar_credito";
  @override
  _ComprarCreditoUIState createState() => _ComprarCreditoUIState();
}



class _ComprarCreditoUIState extends State<ComprarCreditoUI> {
  
  String totalAPagar = '0';
  bool dot = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<ComprarCreditoModel>(
      builder: (context, model, child) => Consumer<User>(
        builder: (context, user, child) => SafeArea(
            child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(//Mi Perfil
                'Comprar Credito',
                style: TextStyle(
                    color: Colors.blue[800],
                    fontFamily: 'Poppins',
                    fontSize: 22.0)),
            leading: IconButton(  // boton de atras
              icon: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30.0,
                  color: Colors.blue[800],
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(            
            padding: EdgeInsets.all(12),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color:Colors.blue[700],
            child: SingleChildScrollView(                  
              child: Column( // Columna con toda la vista
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[                                
                  SizedBox(height: 10),
                  Container( //container con el numero del credito seleccionado para agregar que se esta agregando solamente
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(10),
                      //border: Border.all(color: Colors.blue[800], width: 4.0)
                    ),
                  child: Center(child: Text('\$'+ totalAPagar,style: 
                    TextStyle(fontFamily: 'Sen',color:Colors.white,
                    fontSize: totalAPagar.length < 7 ? 80 : 50, //si el numero del total a pagar es muy grande entonces cambia el tamano de la variable
                      ),maxLines: 1,)),
                ),
                  SizedBox(height: 20,),
                  Container(
                    height: 380,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded( //container con la primera fila numeros 123
                          child: Container( //container con la primera fila numeros 123
                            color:Colors.blue[800],
                            child: Row(
                              children: <Widget>[
                                Expanded( //boton 1
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '1';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '1';
                                          }
                                        });
                                      }, 
                                      child: Text('1',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                                Padding( //Vertical Divider
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                Expanded( //boton 2
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '2';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '2';
                                          }
                                        });
                                      }, 
                                      child: Text('2',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                                Padding( //Vertical Divider
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                Expanded( //boton 3
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '3';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '3';
                                          }
                                        });
                                      }, 
                                      child: Text('3',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding( //Divider
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            color: Colors.white,
                            height: 3.0,
                          ),
                        ),
                        Expanded( //container con la primera fila numeros 456
                          child: Container( //container con la primera fila numeros 123
                            color:Colors.blue[800],
                            child: Row(
                              children: <Widget>[
                                Expanded( //boton 4
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '4';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '4';
                                          }
                                        });
                                      }, 
                                      child: Text('4',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                                Padding( //Vertical Divider
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                Expanded( //boton 5
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '5';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '5';
                                          }
                                        });
                                      }, 
                                      child: Text('5',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                                Padding( //Vertical Divider
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                Expanded( //boton 6
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '6';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '6';
                                          }
                                        });
                                      }, 
                                      child: Text('6',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding( //Divider
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            color: Colors.white,
                            height: 3.0,
                          ),
                        ),
                        Expanded( //container con la primera fila numeros 789
                          child: Container( //container con la primera fila numeros 123
                            color:Colors.blue[800],
                            child: Row(
                              children: <Widget>[
                                Expanded( //boton 7
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '7';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '7';
                                          }
                                        });
                                      }, 
                                      child: Text('7',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                                Padding( //Vertical Divider
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                Expanded( //boton 8
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '8';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '8';
                                          }
                                        });
                                      }, 
                                      child: Text('8',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                                Padding( //Vertical Divider
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                Expanded( //boton 9
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '9';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '9';
                                          }
                                        });
                                      }, 
                                      child: Text('9',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding( //Divider
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            color: Colors.white,
                            height: 3.0,
                          ),
                        ),
                        Expanded( //container con la primera fila numeros . and 0 and backspace
                          child: Container( //container con la primera fila numeros 123
                            color:Colors.blue[800],
                            child: Row(
                              children: <Widget>[
                                Expanded( //boton .
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(dot){
                                            return null;
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '.';
                                            dot = true;
                                          }
                                        });
                                      }, 
                                      child: Text('.',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:40),)
                                    ),
                                  ),
                                ),
                                Padding( //Vertical Divider
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                Expanded( //boton 0
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = '0';
                                          }
                                          else{
                                            totalAPagar = totalAPagar + '0';
                                          }
                                        });
                                      }, 
                                      child: Text('0',style: TextStyle(fontFamily: 'Sen', color: Colors.white, fontSize:34),)
                                    ),
                                  ),
                                ),
                                Padding( //Vertical Divider
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                Expanded( //boton backspace
                                  child: Container(
                                    color:Colors.blue[800],
                                    child: FlatButton(
                                      onLongPress: (){
                                        setState(() {
                                          totalAPagar = '0';
                                        });
                                      },
                                      onPressed: (){
                                        setState(() {
                                          if(totalAPagar == '0'){
                                            totalAPagar = totalAPagar;
                                          }
                                          else{
                                            var length = totalAPagar.length;
                                            if(length == 1){totalAPagar = '0';}
                                            else{
                                              totalAPagar = totalAPagar.substring(0,length - 1);
                                              if(totalAPagar.contains('.')){dot = true;}
                                              else{dot = false;}  
                                            }
                                          }
                                        });
                                      }, 
                                      child: Icon(Icons.backspace,color: Colors.white,size: 30,)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Center( //boton de comprar
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),                        
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
                      color: Colors.blue[800],
                      child: Text('Comprar', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 26),),
                      onPressed: (){
                        if(double.parse(totalAPagar) > Helpers.minAmount){
                          Helpers.fromComprarPage = true;
                          showDialog(context: context,builder: (context) => 
                            CustomAlertDialogs(selection: 1, totalAPagar: double.parse(totalAPagar),));
                        }
                        else{
                          showDialog(context: context, builder:(context){
                            return CustomAlertDialogs(selection: 13,text: 'Solo se puede comprar credito por mas de \$ ${Helpers.minAmount.toString()}.',);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}





