import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/formatter.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/services/validator.dart';
import 'package:pimpineo_v1/services/viewstate.dart';
import 'package:pimpineo_v1/view/base_view.dart';
import 'package:pimpineo_v1/view/us/transacciones.dart';
import 'package:pimpineo_v1/view/us/us_lobby.dart';
import 'package:pimpineo_v1/viewmodels/tarjeta_credito_model.dart';
import 'package:pimpineo_v1/widgets/checkout_dialogs.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:provider/provider.dart';
import 'package:pimpineo_v1/services/size_config.dart';



class CreditCardPurchaseUI extends StatefulWidget { 
  final double totalApagar;   //y este total a pagar se calcula en el boton de enviar recarga tambien
  final List<dynamic> contactosARecargar;  //esta lista se crea en el boton de enviar recarga
  static const String route = "/tarjeta_credito";

  const CreditCardPurchaseUI({Key key, this.totalApagar,this.contactosARecargar}) : super(key: key);

  @override
  _CreditCardPurchaseUIState createState() => _CreditCardPurchaseUIState();
}




class _CreditCardPurchaseUIState extends State<CreditCardPurchaseUI> {

  //para saber si esta viniendo de la pagina de comprar credito
  bool _fromComprarCredito = Helpers.fromComprarPage;

//Form key
  GlobalKey<FormState> _creditCardFormKey = GlobalKey<FormState>();
 

//field validators
  final UserValidator _validator = locator<UserValidator>();
  var _isValidated = false;
  TextEditingController _zipController = TextEditingController();


//card related variables
  bool _saveCard = false;
  int _cardBrandIndex = 0; //to select the index of the Type of Card


//card data
  String _nombreCard;
  String _numeroCard;
  String _fechaCard;
  String _cvvCard;
  String _zipCard = '';  


  //var _selectedAmount;
  var _selectedCard = 0; // index of the card that is selected in the cupertino picker

  double totalApagar;
  bool _switchValue = false;
  double previousCredit;
  double newCredit;
  
  @override
  void initState() {
    super.initState();
    totalApagar = widget.totalApagar;
  }


  @override
  Widget build(BuildContext context) {
    return BaseView<TarjetaCreditoModel>(
      builder: (context, model, child) => Consumer<User>(
        builder: (context, user, child) => SafeArea(
            child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(//Finalizar Compra
                'Finalizar Compra',
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
                Helpers.fromComprarPage = false; //retornando la variable a su posision original
                //asegurar no dejar la ventana con el boton de atras con el credito cambiado
                if(previousCredit == newCredit){
                  Navigator.pop(context);
                }
                else{
                  user.updateCredit(previousCredit);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(//credito disponible
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(  height: 10.0,),
                        RichText( //Credito disponible
                          text: TextSpan( // credito disponible statement
                            text: 'Credito Disponible: ',
                            style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: SizeConfig.resizeHeight(18),
                                  fontFamily: 'Poppins'),
                            children: <TextSpan>[
                              TextSpan( // numero
                                text: '\$' + double.parse(user.credito.toString()).toStringAsFixed(2),
                                style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: SizeConfig.resizeHeight(18),
                                      fontFamily: 'Poppins'),  
                              ),
                            ]  
                          ),
                        ),
                        Divider(thickness: 1, color:Colors.grey),
                        Padding(// aplicar el credito disponible row
                          padding: const EdgeInsets.only(bottom:5.0),
                          child: Row( //credito disponible row
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text( // texto de usar credito disponible
                                'Usar Credito Disponible:',
                                 style: TextStyle(
                                   fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.resizeHeight(18),
                                   fontFamily: 'Poppins'),
                              ),
                              SizedBox(width: SizeConfig.resizeHeight(10)),
                              Container( //switch
                                height: SizeConfig.resizeHeight(30),
                                child: switchStatus(user) //desabilita la posibilidad de usar el credito ya que se esta haciendo una compra de credito
                                ?Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      activeColor: Colors.green,
                                      value: _switchValue, 
                                      onChanged: (value) async { //payment intelligence
        
                                        /*
                                         Esta es la inteligencia del switch para aplicar el credito desde la ventana de pagar con la tarjeta de credito
                                         Opciones: 
                                         1-credito es mayor que el total a pagar
                                         2-si el total a pagar menos monto minimo permitido es mayor o igual que el credito disponiblee
                                         3- si el credito disponible esta entre el total a pagar y el total a pagar menos monto minimo permitido
                                         */
                             
                                        setState(() {
                                          _switchValue = value;
                                        });
                                        
                                        if(value == true){
                                          //1- credito es mayor que el total a pagar o sea puede comprar la recarga con el credito
                                          if(totalApagar <= user.credito){
                                            model.setState(ViewState.Busy);

                                            //aqui se hace la recarga usando el switch solamente aplica a recargas usando credito
                                            var result = await model.enviarRecarga('Recarga usando solo Credito', user.credito, widget.contactosARecargar);                                            
                                            List<Map<String,dynamic>> contactosRecargados = result[0];
                                            if(contactosRecargados.isNotEmpty){
                                              previousCredit = double.parse(user.credito.toString());
                                              newCredit = user.credito - result[2]; //se resta la cantidad por la que se recargo el usuario 
                                              user.updateCredit(newCredit);
                                              setState(() {
                                                totalApagar = 0;                             
                                              }); 
                                              await Helpers.crearRecordParaRecargaConSoloCredito(contactosRecargados, result[2], context);
                                              model.setState(ViewState.Idel);
                                              await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context){
                                                return CustomAlertDialogs(
                                                  selection: 11,
                                                );
                                            }); 
                                              //si sale del show dialogo y no presiona OK entonces todo vuelve hacia atras
                                              user.updateCredit(previousCredit);
                                              setState(() {
                                                totalApagar = widget.totalApagar; 
                                                _switchValue = ! _switchValue;                            
                                              });
                                            }
                                          }
                                          //2- si el total a pagar menos monto minimo permitido es mayor o igual que el credito disponible
                                          else if(user.credito <= (totalApagar - Helpers.minAmount)){
                                            previousCredit = double.parse(user.credito.toString());
                                            setState(() {
                                              totalApagar = totalApagar - user.credito; 
                                            });
                                            newCredit = 0;     
                                            user.updateCredit(newCredit);                        
                                          }
                                          //3- si el credito disponible esta entre el total a pagar y el total a pagar menos monto minimo permitido
                                          else if(user.credito < totalApagar){
                                            previousCredit = double.parse(user.credito.toString());
                                            await showDialog( //muestra el dialogo dejando saber al cliente que sera aplicado el credito parcialmente
                                              context: context,
                                              builder: (context){
                                                return CustomAlertDialogs(
                                                  totalAPagar: totalApagar,
                                                  selection: 10,
                                                );
                                            });
                                            //de esta manera vuelvo atras si el cliente no presiono el boton de THUMBS UP una vez que el aparacio el dialogo con la aclaracion de un minimo permitido
                                            if(Helpers.clienteAgreed == false){
                                              user.updateCredit(previousCredit);
                                              setState(() {
                                                totalApagar = widget.totalApagar; 
                                                _switchValue = ! _switchValue;                            
                                              });
                                            }
                                            else{
                                              Helpers.clienteAgreed = false;
                                              double creditoAplicable = totalApagar - Helpers.minAmount; //el credito aplicable es el mayor credito aplicable posible dejando monto minimo permitido para pagar con tarjeta
                                              newCredit = user.credito - creditoAplicable;
                                              setState(() {
                                                totalApagar = Helpers.minAmount;
                                              });
                                              user.updateCredit(newCredit);
                                            }
                                          }
                                        }
                                        else{
                                          setState(() {
                                            totalApagar = widget.totalApagar;
                                          });
                                          user.updateCredit(previousCredit);
                                        }                            
                                      }
                                    ),
                                  ) //muestra un candado cuando lo que se va a hacer es comprar credito
                                :Container(color:Colors.white,child: Icon(Icons.lock,color:Colors.red),),
                              )
                              ],
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(10),),
                  Center( //TOTAL A PAGAR
                    child: Container( // total a pagar
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(5),
                        ),
                      child: Center( //TOTAL A PAGAR
                        child: RichText(
                          text: TextSpan(
                            text: 'TOTAL:',
                            style: TextStyle(
                              color:  Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.resizeHeight(20),
                              fontFamily: 'Poppins'),
                            children: <TextSpan>[
                              TextSpan(
                                text: '  \$' + totalApagar.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: SizeConfig.resizeHeight(32)
                                )
                              )
                            ]
                          )
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.blue[800],thickness: 2,), //****++++***** Metodos de pago de este punto hacia debajo
                  model.state == ViewState.Idel 
                  ?Container( // metodo de pago
                      child: Column( //metodos de pago
                        children: <Widget>[
                          Container( //cupetino picker
                                  width: double.maxFinite,
                                  height: SizeConfig.resizeHeight(60),
                                  alignment: Alignment.center,
                                  child: CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 25.0,
                                      onSelectedItemChanged: (itemIndex) {
                                        setState(() {
                                          //we need to put back the modified variables in the new card that were manually corected 
                                          _saveCard = false;
                                          _isValidated = false;
                                          _zipController.clear();
                                          //seleting the card in the picker with that index
                                          _selectedCard = itemIndex;
                                        });
                                      },
                                      children: model.getCardsInFileList(context)),
                                ),
                          SizedBox(height:SizeConfig.resizeHeight(10)),
                          Container(//credit card module
                            child: _selectedCard == 0
                               ? Column( // tarjeta de credito con el boton de comprar
                                 children: <Widget>[
                                   Padding(  //credit card box
                                     padding: const EdgeInsets.symmetric(
                                         horizontal: 10.0),
                                     child: AnimatedContainer( 
                                       duration: Duration(milliseconds: 500),
                                       height: 220.0,
                                       width: double.infinity,
                                       decoration: BoxDecoration( //decoracion con el borde de la tarjeta en rojo o verde
                                           color: _isValidated == true 
                                           ?Colors.blue[200]
                                           :Colors.white,
                                           boxShadow: [
                                             BoxShadow(
                                                 color: Colors.black26,
                                                 offset: Offset(0.0, 4.0),
                                                 blurRadius: 4.0),
                                             BoxShadow(
                                                 color: Colors.black26,
                                                 offset: Offset(0.0, -4.0),
                                                 blurRadius: 4.0)
                                           ],
                                           border: Border.all(
                                               color: _isValidated == false 
                                               ?Colors.red
                                               :Colors.green,
                                               style: BorderStyle.solid,
                                               width: 1.0),
                                           borderRadius: BorderRadius.circular(10.0)),
                                       child: Form(  //**********credit card form */
                                         key: _creditCardFormKey,
                                         autovalidate: false,
                                         child: Column( // columna con la informacion dentro de la tarjeta de  credito
                                           children: <Widget>[
                                             Padding( // nombre
                                               padding: const EdgeInsets.only(top: 2.0, right: 10.0, left: 10.0),
                                               child: TextFormField(
                                                 style: TextStyle(
                                                   fontFamily: 'Solway'
                                                 ),
                                                 autovalidate: true,
                                                 onChanged: (value){
                                                   _zipController.clear();
                                                   _nombreCard = value;
                                                   if(_creditCardFormKey.currentState.validate()){
                                                     setState(() {
                                                       _isValidated = true;
                                                     });
                                                   }
                                                   else{
                                                     setState(() {
                                                         _isValidated = false;
                                                     });
                                                   }
                                                 },
                                                 textCapitalization: TextCapitalization.words,
                                                 validator: _validator.validateNombreCreditCard,
                                                 keyboardType: TextInputType.text,
                                                 decoration: InputDecoration(
                                                   errorStyle: TextStyle(height: 0),
                                                   enabledBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                     borderSide: BorderSide(
                                                       width: 2.0, 
                                                       style: BorderStyle.solid,
                                                       color: Colors.green
                                                     )
                                                   ),
                                                   focusedBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                     borderSide: BorderSide(
                                                       width: 2.0, 
                                                       style: BorderStyle.solid,
                                                       color: Colors.blue
                                                     )
                                                   ),
                                                   hintText: 'Nombre en la tarjeta',
                                                   hintStyle: TextStyle(
                                                     fontFamily: 'Solway'
                                                   )
                                                 ),
                                               ),
                                             ),
                                             Padding( // numero de la tarjeta
                                               padding: const EdgeInsets.only(top: 2.0, right: 10.0, left: 10.0),
                                               child: TextFormField(
                                                 style: TextStyle(
                                                   fontFamily: 'Solway'
                                                 ),
                                                 autovalidate: true,
                                                 validator: _validator.validateNumeroCreditCard,
                                                 onChanged: (val){  //le da el valor del primer numero a el arreglo de las fotos de las tarjetas
                                                   var char0 = val[0];
                                                   setState(() {
                                                     _cardBrandIndex = int.parse(char0);
                                                   });
                                                   _numeroCard = val;
                                                   _zipController.clear();
                                                   if(_creditCardFormKey.currentState.validate()){
                                                     setState(() {
                                                       _isValidated = true;
                                                     });
                                                    }
                                                    else{
                                                      setState(() {
                                                          _isValidated = false;
                                                      });
                                                    }
                                                 },
                                                 keyboardType: TextInputType.number,
                                                 inputFormatters: [
                                                   TextFormatter(
                                                     mask: _cardBrandIndex == 3
                                                     ?'xxxx-xxxxxx-xxxxx'
                                                     :'xxxx-xxxx-xxxx-xxxx',
                                                     separator: '-',
                                                   ),
                                                 ],
                                                 decoration: InputDecoration(
                                                   errorStyle: TextStyle(height: 0),
                                                   enabledBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                     borderSide: BorderSide(
                                                       width: 2.0, 
                                                       style: BorderStyle.solid,
                                                       color: Colors.green
                                                     )
                                                   ),
                                                   focusedBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                     borderSide: BorderSide(
                                                       width: 2.0, 
                                                       style: BorderStyle.solid,
                                                       color: Colors.blue
                                                     )
                                                   ),
                                                   hintText: 'xxxx-xxxx-xxxx-xxxx',
                                                   hintStyle: TextStyle(
                                                     fontFamily: 'Solway'
                                                   )
                                                 ),
                                               ),
                                             ),
                                             Container( // tres ultimos campos de la tarjeta
                                               height: 60,
                                               width: double.infinity,
                                               child: Padding(
                                                 padding: const EdgeInsets.only(left:10.0,right: 10.0),
                                                 child: Flex(
                                                   direction: Axis.vertical,
                                                   crossAxisAlignment: CrossAxisAlignment.stretch,
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   children: <Widget>[
                                                     Row( // MM/YY CVV Zip code
                                                       children: <Widget>[
                                                         Expanded(flex: 2, child: TextFormField( // mm/yy
                                                           style: TextStyle(
                                                             fontFamily: 'Solway'
                                                           ),
                                                           autovalidate: true,
                                                           onChanged: (value){
                                                             _zipController.clear();
                                                             _fechaCard = value;
                                                             if(_creditCardFormKey.currentState.validate()){
                                                                 setState(() {
                                                                   _isValidated = true;
                                                                 });
                                                               }
                                                               else{
                                                                 setState(() {
                                                                     _isValidated = false;
                                                                 });
                                                               }
                                                           },
                                                           validator: _validator.validateFechaCreditCard,
                                                           keyboardType: TextInputType.number,
                                                           inputFormatters: [
                                                             TextFormatter(
                                                               mask: 'MM/YY',
                                                               separator: '/',
                                                             ),
                                                           ],
                                                           decoration: InputDecoration(
                                                             errorStyle: TextStyle(height: 0),
                                                             enabledBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                               borderSide: BorderSide(
                                                                 width: 2.0, 
                                                                 style: BorderStyle.solid,
                                                                 color: Colors.green
                                                               )
                                                             ),
                                                             focusedBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                               borderSide: BorderSide(
                                                                 width: 2.0,
                                                                 style: BorderStyle.solid,
                                                                 color: Colors.blue
                                                             )
                                                           ),
                                                             hintText: 'MM/YY',
                                                             hintStyle: TextStyle(
                                                               fontFamily: 'Solway'
                                                             )
                                                           ),
                                                         )),
                                                         SizedBox(width: 10,),
                                                         Expanded(flex: 1, child: TextFormField( //cvv
                                                           style: TextStyle(
                                                             fontFamily: 'Solway'
                                                           ),
                                                           autovalidate: true, 
                                                           onChanged: (value){
                                                             _cvvCard = value;
                                                             _zipController.clear();
                                                               if(_creditCardFormKey.currentState.validate()){
                                                                 setState(() {
                                                                   _isValidated = true;
                                                                 });
                                                               }
                                                               else{
                                                                 setState(() {
                                                                   _isValidated = false;
                                                                 });
                                                               }
                                                           },
                                                           validator: _validator.validateCVVCreditCard,
                                                           obscureText: true,
                                                           keyboardType: TextInputType.number,
                                                           inputFormatters: [
                                                             TextFormatter(
                                                               mask: _cardBrandIndex == 3
                                                               ?'xxxx'
                                                               :'xxx',
                                                               separator: '',
                                                             ),
                                                           ],
                                                           decoration: InputDecoration(
                                                             errorStyle: TextStyle(height: 0),
                                                             enabledBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                               borderSide: BorderSide(
                                                                 width: 2.0, 
                                                                 style: BorderStyle.solid,
                                                                 color: Colors.green
                                                               )
                                                             ),
                                                             focusedBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                               borderSide: BorderSide(
                                                                 width: 2.0,
                                                                 style: BorderStyle.solid,
                                                                 color: Colors.blue
                                                             )
                                                           ),
                                                             hintText: 'CVV',
                                                             hintStyle: TextStyle(
                                                               fontFamily: 'Solway'
                                                             )
                                                           ),
                                                         )),
                                                         SizedBox(width: 10,),
                                                         Expanded(flex: 2, child: TextFormField( //zip
                                                           style: TextStyle(
                                                             fontFamily: 'Solway'
                                                           ),
                                                           textInputAction: TextInputAction.done,
                                                           controller: _zipController,
                                                           autovalidate: true,
                                                           onChanged: (value){
                                                               _zipCard = value;
                                                               if(value.length == 5){
                                                                 if(_creditCardFormKey.currentState.validate()){
                                                                 setState(() {
                                                                   _isValidated = true;
                                                                 });
                                                                 }
                                                                 else{
                                                                 _zipController.clear();
                                                                 setState(() {
                                                                     _isValidated = false;
                                                                 });
                                                                 }
                                                               } 
                                                               else{
                                                                 setState(() {
                                                                   _isValidated = false;
                                                                 });
                                                               }
                                                           },
                                                           validator: _validator.validateZIPCreditCard,
                                                           keyboardType: TextInputType.number,
                                                           inputFormatters: [
                                                             TextFormatter(
                                                               mask: 'xxxxx',
                                                               separator: '',
                                                             ),
                                                           ],
                                                           decoration: InputDecoration(
                                                             errorStyle: TextStyle(height: 0),
                                                             enabledBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                               borderSide: BorderSide(
                                                                 width: 2.0, 
                                                                 style: BorderStyle.solid,
                                                                 color: Colors.green
                                                               )
                                                             ),
                                                             focusedBorder: UnderlineInputBorder(  //verde si validado rojo si no validado
                                                               borderSide: BorderSide(
                                                                 width: 2.0,
                                                                 style: BorderStyle.solid,
                                                                 color: Colors.blue
                                                             )
                                                           ),
                                                             hintText: 'ZIP Codigo',
                                                             hintStyle: TextStyle(
                                                               fontFamily: 'Solway'
                                                             )
                                                           ),
                                                         )),
                                                         ],
                                                     )
                                                   ],
                                                 ),
                                               ),
                                             ),
                                             SizedBox(height: 5.0,),
                                             AnimatedContainer( //linea al final
                                               child: Container(
                                                 alignment: Alignment(1, 1),
                                                 decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                 ),
                                                 padding: const EdgeInsets.only(top:4.0,bottom:4.0,right:10),
                                                 child: Image.asset(model.getCardImage(_cardBrandIndex)),
                                               ),
                                               duration: Duration(milliseconds: 500),
                                               curve: Curves.easeIn,
                                               decoration: BoxDecoration(
                                                 gradient: _isValidated == false
                                                 ?LinearGradient(colors: [Colors.grey[500],Colors.grey[50]],)
                                                 :LinearGradient(colors: [Colors.grey[50],Colors.grey[500]],)
                                               ),
                                               height: 40,
                                               width: double.infinity,
                                             )
                                           ],
                                         ),
                                       ),
                                     ),
                                   ),
                                   ListTile(  // guardar la tarjeta en records
                                     onTap: (){
                                       setState(() {
                                         _saveCard = !_saveCard;
                                       });
                                     },
                                     contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.resizeWidth(14)),
                                     leading: _saveCard == false 
                                     ?Icon(Icons.check_box_outline_blank)
                                     :Icon(Icons.check_box, color: Colors.green,),
                                     title: _saveCard == false
                                     ?Text('Desea salvar esta tarjeta de credito?', style: TextStyle(color: Colors.grey[600] ,fontFamily: 'Poppins',fontSize: SizeConfig.resizeHeight(16)),)
                                     :Text('Si, deseo salvar esta tarjeta.', style: TextStyle(color: Colors.grey[900] ,fontFamily: 'Poppins', fontSize: SizeConfig.resizeHeight(16)),),
                                   ),
                                   FlatButton( //boton de comprar con nueva tarjeta en el modulo de la tarjeta de credito
                                     onPressed: () async {
                                       var result;
                                       Helpers.fromComprarPage = false; //retornando la variable a su posision original
                                       if(_zipCard.length == 5){
                                         //accion de comprar
                                         if(_creditCardFormKey.currentState.validate()){
                                           model.setState(ViewState.Busy);
                                           result = await paymentLogic(context, model, user, 'new'); 
                                           if(result){
                                             setState(() {
                                               Helpers.fromComprarPage = false;
                                               Helpers.lastroute = 'recargas';
                                               model.setState(ViewState.Idel);                                               
                                             });
                                             await transaccionExistosa(context);
                                             Navigator.pushNamedAndRemoveUntil(context , LobbyUS.route, (Route<dynamic> route) => false );
                                           }
                                           model.setState(ViewState.Idel);
                                         }
                                       }
                                       else{
                                         return null;
                                       }
                                     },
                                     padding: EdgeInsets.symmetric(vertical:8.0, horizontal: 40.0),
                                     shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0)),
                                     color: _isValidated == false
                                       ?Colors.grey[400]
                                       :Colors.blue[800],
                                     child: Text(
                                                'Comprar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20.0
                                                ),
                                              )
                                   )
                                ],
                               )
                               : Container( // boton de comprar con tajeta en record
                                 padding: EdgeInsets.only(top:20.0),
                                 child: FlatButton( //+++++++++++++INTELIGENCIA PARA COMPRAR CON LA TARJETA QUE ESTA EN RECORD
                                   onPressed: () async {
                                     var result;
                                     model.setState(ViewState.Busy);
                                     result = await paymentLogic(context, model, user, 'saved');
                                     if(result){
                                       setState(() {
                                         Helpers.fromComprarPage = false;
                                         Helpers.lastroute = 'recargas';
                                         model.setState(ViewState.Idel);
                                       });
                                       await transaccionExistosa(context);
                                       Navigator.pushNamedAndRemoveUntil(context , LobbyUS.route, (Route<dynamic> route) => false );
                                     }
                                     model.setState(ViewState.Idel);
                                   },
                                   padding: EdgeInsets.symmetric(vertical:8.0, horizontal: 40.0),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(8.0)),
                                   color: Colors.blue[800],
                                   child: Text(
                                     'Comprar',
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontWeight: FontWeight.w600,
                                       fontFamily: 'Poppins',
                                       fontSize: 20.0
                                     ),
                                   )
                                 )
                                )
                             ),
                           ],
                      ))
                  :Helpers.customProgressIndicator()
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }




///function con la inteligencia de los botones de 'Comprar'
  Future<dynamic> paymentLogic(BuildContext context, TarjetaCreditoModel model, User user, String cardType) async {

       bool result;
       var finalResult;
       String type;

       //significa que solamente se va a comprar credito., no hay que llamar la recarga
       if(_fromComprarCredito == true){
         type = 'Compra de Credito'; //compra de credito
         print(type);
            if(cardType == 'new'){
              result = await model.makePaymentNewCard(context, _saveCard, totalApagar, _nombreCard, _numeroCard, _fechaCard, _cvvCard, _zipCard, type, true);}
            else{
              result = await model.makePaymentSavedCard(context, _selectedCard, totalApagar, type, true);
            }

            if(result){
              setState(() {  //actualiza el credito en la aplicacion
                user.updateCredit((totalApagar + double.parse(user.credito.toString())));
                model.updateListadoTransacciones(user);
              });
              return result;
            }
            else{
              showDialog(context: context,builder: (context){return CustomAlertDialogs(selection: 13,text: 'Hubo un error cargando la tarjeta. Revise todos los datos e intentelo nuevamente.',);});
              setState(() {
                model.setState(ViewState.Idel);
              });
              return result;
            }
       }
       else{
           /** Inteligencia para enviar la recarga y el cobro de la tarjeta  
            * Pasa la tarjeta para ver que se le puede cobrar, luego confirma la transaccion esta parte de la inteligencia esta en el backend 
           */
           //1-crea el tipo de transaccion que se esta mandando a hacer
           if(_switchValue){
             type = 'Recarga usando Tarjeta y Credito'; //usando tarjeta y credito
           }
           else{
            type = 'Recarga usando solo Tarjeta'; //usanado solo tarjeta
           }

           //2-se le va a hacer el cargo a la tajeta pero sin capturar, se captura luego de que ya se aprobaron las recargas
           if(cardType == 'new'){result = await model.makePaymentNewCard(context, _saveCard, totalApagar, _nombreCard, _numeroCard, _fechaCard, _cvvCard, _zipCard, type, false);}
           else{result = await model.makePaymentSavedCard(context, _selectedCard, totalApagar, type, false);}
           
           //3-envia la recarga
            var recargaResult = await model.enviarRecarga(type, user.credito, widget.contactosARecargar);
            print(recargaResult.toString() + ' recarga result ');
           
            //4- chequea que la recarga fue enviada completa
           if(recargaResult[2] != totalApagar){ //si el amount cambio porque fallo algun numero de telefono durante la recarga
               double newTotalAPagar = recargaResult[2];
             
               if(_switchValue){
                  if((newTotalAPagar-previousCredit) > Helpers.minAmount){
                    newTotalAPagar = newTotalAPagar - previousCredit;  
                    //significa que todo el credito fue aplicado a la compra
                    setState(() {
                      user.updateCredit(0.00);
                    });                                                    
                  }
                  else if((newTotalAPagar-previousCredit) <= 0){ 
                    //no se cobra tarjeta, solamente se le aplica al credito
                    setState(() {
                      user.updateCredit(previousCredit - newTotalAPagar);
                    }); 
                    newTotalAPagar = 0.00;                                                    
                  }
                  else{
                    //se cobra monto minimo permitido en tarjeta y la diferencia se le pone al credito 
                    double updatecredito = previousCredit - (newTotalAPagar - Helpers.minAmount); 
                    newTotalAPagar = Helpers.minAmount;                                                    
                    setState(() {
                      user.updateCredit(updatecredito);                                                                                                                                                                        
                    });                                                                                                                                                                 
                  }
                  //5- process payment con el nuevo total a pagar con credito aplicado como pedido por el cliente
                 finalResult = await model.processPayment(type, newTotalAPagar, user.uid, recargaResult[0]);
               }else{
                 //5- process payment al total nuevo pero sin credito aplicado
                 finalResult = await model.processPayment(type, newTotalAPagar, user.uid, recargaResult[0]);
               }
           }else{
             //process payment con el mismo amount
            finalResult = await model.processPayment(type, totalApagar, user.uid, recargaResult[0]);
           }
           //esta linea es para actualizae la lista luego de que se hizo el segundo paso del pago
           setState(() {
             model.updateListadoTransacciones(user);
           });
          
           return finalResult;
        }

  }


  
///function para poner el candado o el switch
  bool switchStatus(User user){
    if((_fromComprarCredito == true)||(user.credito == 0)){
      return false; //pon el candado
    }
    else{
      return true; //pon el switch
    }
  }


  
///function para sacar el cartel de que la transaccion fue exitosa
  transaccionExistosa(BuildContext context) async {
    return await showGeneralDialog(
      context: context, 
      pageBuilder: (context,a1,a2){
        //Future.delayed(Duration(seconds: 6),(){Navigator.pop(context);});
        final curvedValue = Curves.bounceIn.transform(a1.value);
        return Transform(
          origin: Offset(1,5),
          transform: Matrix4.translationValues(1.0, curvedValue, 1.0),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check, color:Colors.green,size: 60,),
                  SizedBox(height: 5),
                  Text('La transaccion ha sido existosa.', style: TextStyle(color: Colors.blue[800],fontFamily: 'Poppins',fontSize: SizeConfig.resizeHeight(14)),),
                  SizedBox(height: 5),
                  Text('Gracias por su compra!', style: TextStyle(color: Colors.blue[800],fontFamily: 'Poppins',fontSize: SizeConfig.resizeHeight(14)),),
                  SizedBox(height: 5),
                  Text('Equipo de Pimpineo', style: TextStyle(color: Colors.blue[800],fontFamily: 'Pacifico',fontSize: SizeConfig.resizeHeight(20)),), 
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){Navigator.pushNamedAndRemoveUntil(context, LobbyUS.route , (Route<dynamic> route) => false);},
                        child: Text('Inicio', style: TextStyle(color: Colors.blue[800],fontFamily: 'Poppins',decoration:TextDecoration.underline,))),
                      SizedBox(width: 5,),
                      GestureDetector(
                        onTap: (){Navigator.pushNamedAndRemoveUntil(context, TransaccionesUI.route , (Route<dynamic> route) => false);},
                        child: Text('No. Confirmacion', style: TextStyle(color: Colors.blue[800],fontFamily: 'Poppins',decoration:TextDecoration.underline,))),
                    ],
                  ),
                  
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



