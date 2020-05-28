import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/enviar_recarga.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:pimpineo_v1/viewmodels/transacciones_viewmodel.dart';
import 'package:pimpineo_v1/widgets/credit_card.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class TransaccionesUI extends StatefulWidget {
  static const String route = '/transacciones';
  @override
  _TransaccionesUIState createState() => _TransaccionesUIState();
}



class _TransaccionesUIState extends State<TransaccionesUI> {
  List<String> values = ['5','10','20','50','60'];
  String seleccionado = '10';

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TransaccionesViewModel>.withConsumer(
      viewModel: TransaccionesViewModel(),
      onModelReady:(model) => model.getTransacciones(context),
      builder: (context , model , child ){
        return SafeArea(
          child: Scaffold(
            bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('Mostrar: ',style: TextStyle(fontFamily: 'Poppins'),),
                Container(
                  color: Colors.transparent,
                  height: 40,
                  child: DropdownButton<String>(
                    value: seleccionado,
                    items: values.map((value) => DropdownMenuItem(
                      child: Text(value,style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),),
                      value: value,
                    )).toList(),
                    onChanged: (selected){
                      setState(() {
                         seleccionado = selected;
                      });
                    })
                ),
              ],
            ),         
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text(//Mi Perfil
                  'Listado de Transacciones',
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
            body: ListView.builder(
              itemCount: int.parse(seleccionado) >= model.transacciones.length ? model.transacciones.length : int.parse(seleccionado),
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.only(right:10.0, left: 10, top: 6, bottom: 6),
                  child: Column(
                    children: <Widget>[
                      Center( //fecha en la lista de transacciones
                        heightFactor: 1,   //multiply by 1000 since epoch due to Stripe created the dates in seconds since unix epoch and Dart create the TimeStamps in milisecondossince unix epoch
                        child: Text(
                          model.transacciones[index]['type'] == 'Recarga usando solo Credito' //pregunta si la recarga es solo usando credito
                          ?DateTime.fromMillisecondsSinceEpoch(model.transacciones[index]['timestamp']).toString():DateTime.fromMillisecondsSinceEpoch(model.transacciones[index]['timestamp']*1000).toString(),
                            style: TextStyle(
                              fontFamily: 'Sen', 
                              color: Colors.grey,
                              fontSize: 12
                        ),),
                      ),
                      Slidable( //muestra el boton de slide cuando se hace la accion hacia la izquierda
                        closeOnScroll: true,
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.green
                              ),
                              child: FlatButton( //slidable button que te lleva a repetir la transaccion
                                onPressed: () async {
                                  double totalAPagar;
                                   //te manda para la compra con el totoal recalculado
                                  if(model.transacciones[index]['type'] == 'Recarga usando Tarjeta y Credito'){
                                    //para recalcular el total a pagar nuevamente necesito pasarle la lista de a los que se les pago y recalcular porque el total reflejado en las transacciones va a ser solo lo que se pago con tarjeta
                                    double totalAPagarParaDosMetodosDePagoRecalculada = await CallEnviarRecarga.calcularTotalAPagar(model.transacciones[index]['telefonosRecargados']); 
                                    totalAPagar = totalAPagarParaDosMetodosDePagoRecalculada;
                                  }else if(model.transacciones[index]['type'] == 'Compra de Credito'){
                                    Helpers.fromComprarPage = true;
                                    totalAPagar = model.transacciones[index]['cantidad'] is double ? model.transacciones[index]['cantidad'] : model.transacciones[index]['cantidad'].toDouble();
                                  }
                                  else{
                                    totalAPagar = model.transacciones[index]['cantidad'] is double ? model.transacciones[index]['cantidad'] : model.transacciones[index]['cantidad'].toDouble();
                                  }
                                  //te navega para el credit card widget
                                  showDialog(context: context, builder: (context){
                                    return CreditCardPurchaseUI(
                                      contactosARecargar: model.transacciones[index]['telefonosRecargados'],
                                      totalApagar: totalAPagar
                                    );
                                  });
                                }, 
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.repeat, color:Colors.white),
                                    Text('Repetir', style: TextStyle(fontFamily: 'Poppins', color: Colors.white),)
                                  ],
                                )),
                            ),
                          ),
                        ],
                        child: Container( //tile del record de la transaccion 
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                               RichText( //tipo de transaccion
                                 text: TextSpan(
                                   text: 'Transaccion: ',
                                   style: TextStyle(
                                     color: Colors.grey[900],
                                     fontFamily: 'Poppins',
                                     fontSize: 15,
                                   ),
                                   children: <TextSpan>[
                                     TextSpan(text: model.transacciones[index]['type'],style: TextStyle(fontStyle: FontStyle.italic))
                                   ]
                                 )),
                               RichText( //cantidad por la cual se hizo la transaccion
                                 text: TextSpan(
                                   text: 'Precio: ',
                                   style: TextStyle(
                                     color: Colors.grey[900],
                                     fontFamily: 'Poppins',
                                     fontSize: 15,
                                   ),
                                   children: <TextSpan>[
                                     TextSpan(text: '\$' +  model.transacciones[index]['cantidad'].toString() ,style: TextStyle(fontStyle: FontStyle.italic))
                                   ]
                                 )),
                               model.transacciones[index]['type'] == 'Compra de Credito' 
                               ?SizedBox()
                               :RichText( //cantidad por la cual se hizo la transaccion
                                 text: TextSpan(
                                   text: 'Tel Recargados: ',
                                   style: TextStyle(
                                     color: Colors.grey[900],
                                     fontFamily: 'Poppins',
                                     fontSize: 15,
                                   ),
                                   children: <TextSpan>[
                                     TextSpan(text: model.transacciones[index]['telefonosRecargadosString'].toString() ,style: TextStyle(fontStyle: FontStyle.italic))
                                   ]
                                 )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,)
                    ],
                  ),
                );
              }),
          ),
        );
      },       
    );
  }
}