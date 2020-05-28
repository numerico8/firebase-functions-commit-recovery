import 'package:flutter/material.dart';


class MainCarousel extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {


//instancias de prueba para el desarrollo el UI
    List<String> nombre = ['Luis','Pepe','Jose','Mario','Felipe','Jose Luis','Ignacio'];
    List<String> telefono = ['123456','568978','895623','459865','987521','987456','567890'];
  
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text( //Enviar Dinero
            'Enviar dinero',
            style: TextStyle(
                color: Colors.blue[800],
                fontSize: 28.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700),
          ),
        ]),
        SizedBox(height: 20.0,),
        Container(//Listview container
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                offset: Offset(0.0, 6.0),
                blurRadius: 5.0),
            BoxShadow(
                color: Colors.grey[400],
                offset: Offset(0.0, -6.0),
                blurRadius: 5.0)
          ]
          ),
          height: 420.0,
          width: 360.0,
          child: ListView.separated(//Lista 
            separatorBuilder: (context, index){ //separator container
              return Center(
                child: Container(
                  color: Colors.lightBlue[200],
                  height: 2.0,
                  width: 330.0,
                ),
              );             
            },
            itemCount: nombre.length ,
            itemBuilder: (BuildContext context, index){
              return ListTile( //partes de las listas
                trailing: Icon(Icons.send, color: Colors.blue[800],size: 35.0,),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                title: Text(nombre[index], style: TextStyle(fontFamily: 'Poppins', fontSize: 22.0, fontWeight: FontWeight.w600,color: Colors.grey[800]),),
                subtitle: Text(telefono[index], style: TextStyle(fontFamily: 'Sen', fontSize: 20.0),),
              );
            })
          ),
      ],
    );
  }


}
