import 'package:flutter/material.dart';


class MainCarouselEnviar extends StatefulWidget {

  
//instancias de prueba para el desarrollo el UI
  @override
  _MainCarouselEnviarState createState() => _MainCarouselEnviarState();
}

class _MainCarouselEnviarState extends State<MainCarouselEnviar> {
    List<String> nombre = ['Luis','Pepe','Jose','Mario','Felipe','Jose Luis','Ignacio'];

    List<String> nombredisplay = ['Luis','Pepe','Jose','Mario','Felipe','Jose Luis','Ignacio'];

    List<String> telefono = ['123456','568978','895623','459865','987521','987456','567890'];
    

    @override
  void initState() {
    super.initState();
    nombredisplay = nombre;
  }


  @override
  Widget build(BuildContext context) {
  
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.send, color: Theme.of(context).primaryColor, size: 30.0,),
          SizedBox(width:15.0,),
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
          height: 430.0,
          width: 360.0,
          child: ListView.separated(//Lista 
            separatorBuilder: (context, index){ //separator container
              return Center(
                child: Container(
                  color: Colors.yellow[600],
                  height: 2.0,
                  width: 330.0,
                ),
              );             
            },
            itemCount: nombredisplay.length + 1 ,
            itemBuilder: (BuildContext context, index) {
                  return index == 0 ? _searchBar() :  _listItem(index-1);
                }
            )
          ),
      ],
    );
  }

  _searchBar(){
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Icon(Icons.search,size: 20.0,),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: SizedBox(
            width: 200,
            child: TextField(
              onChanged: (text){
                text = text.toLowerCase();
                setState(() {
                  nombredisplay  = nombre.where((nombre){
                    nombre = nombre.toLowerCase();
                    var result = nombre.contains(text);
                    return result;
                  }).toList();
                });
              },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ) ,
                hintText: 'Buscar Contacto',
                hintStyle: TextStyle(
                  fontFamily: 'Sen',
                )
              ),
            ),
          ),
        ),
      ],
    );
  }

  _listItem(index) {
    return ListTile(
      //partes de las listas
      trailing: Icon(
        Icons.send,
        color: Colors.blue[800],
        size: 30.0,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      title: Text(
        nombredisplay[index],
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800]),
      ),
      subtitle: Text(
        telefono[index],
        style: TextStyle(fontFamily: 'Sen', fontSize: 18.0),
      ),
    );
  }
}
