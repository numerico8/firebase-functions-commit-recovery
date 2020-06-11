import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pimpineo_v1/view/base_view.dart';
import 'package:pimpineo_v1/view/login.dart';
import 'package:pimpineo_v1/viewmodels/us_lobby_model.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:pimpineo_v1/widgets/main_carousel_contactos.dart';
import 'package:pimpineo_v1/widgets/main_carousel_home.dart';
import 'package:pimpineo_v1/widgets/main_carousel_recargar.dart';
import 'package:pimpineo_v1/widgets/my_drawer.dart';
import 'package:pimpineo_v1/services/size_config.dart';



class LobbyUS extends StatefulWidget {
  static const String route = '/lobby_us';

  @override
  _LobbyUSState createState() => _LobbyUSState();
}

class _LobbyUSState extends State<LobbyUS> {

  ScaffoldState scaffold;

//icon selector
  int _selectedIndex = 0;

  //animation variables
  int _mainCarouselIndex = 0;
  double screenWidth, screenHeight;
  Duration duration = new Duration(milliseconds: 300);
  bool _iscollapsed = true;


//List with all icons
  List<IconData> _icons = [
    FontAwesomeIcons.home, //home
    FontAwesomeIcons.plug, //hacer recarga
    //Icons.send, //transfer
    //FontAwesomeIcons.exchangeAlt, //compra credito
    FontAwesomeIcons.addressBook, //lista de contactos
  ];


//colors for the widgets
  List<Color> _colors = [
    Colors.blue[800],
    Colors.green[700],
    //Colors.yellow[600],
    //Colors.lightBlue[200],
    Colors.red[400],
  ];


//carousel widget
  List<Widget> _maincarousel = [
    MainCarouselHome(),
    MainCarouselRecargar(),
    //MainCarouselEnviar(),
    //MainCarouselTransfer(),
    MainCarouselContactos()
  ];


//build icon with the icons bar draw
  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _mainCarouselIndex = index;
        });
      },
      child: Container(
        child: Icon(
          _icons[index],
          size: SizeConfig.resizeHeight(30),
          color: _selectedIndex == index ? _colors[index] : Colors.grey,
        ),
        height: SizeConfig.resizeHeight(50),
        width: SizeConfig.resizeWidth(50),
        decoration: BoxDecoration(
          border: _selectedIndex == index 
            ? Border(bottom: BorderSide(color: _colors[index] ,style: BorderStyle.solid,width:3.0))
            : Border.all(color: Colors.white,style: BorderStyle.solid,width:1.0),
        ),
      ),
    );
  }

  
  @override
  void initState() {
    super.initState();
    WidgetsBinding //this is to show the snack bar once logged in
    .instance
    .addPostFrameCallback((_) {
      if(Helpers.lastroute == 'recargas'){
        setState(() {
          Helpers.fromComprarPage = false; 
          Helpers.lastroute = '';
        });
        return this.showSnackBar('Gracias por su compra!!');
      }else if(Helpers.lastroute == 'transacciones'){
        setState(() {
          Helpers.lastroute = '';
        });
        return;
      }
      return this.showSnackBar("Bienvenid@ a Pimpineo.");
    });
  }


  void showSnackBar(String message){
    scaffold
    .showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(seconds: 4),
      content: Text(message,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Sen'
      ),
      )
    )
  );} 

  @override
  Widget build(BuildContext context) {

//this is for the animation
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return SafeArea(
      child: BaseView<USLobbyModel>(
        onModelReady: (model) => model.getUser(context),
        builder: (context,model,child) => SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              title: Text(//pimpineo
                'Pimpineo',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Pacifico',
                  fontSize: SizeConfig.resizeHeight(28)
                )
             ),
              centerTitle: true,
              leading: IconButton(//menu
                icon: Padding(
                  padding: EdgeInsets.only(left:5.0),
                  child: _iscollapsed == true 
                    ? Icon(Icons.dehaze,size: SizeConfig.resizeHeight(35),)
                    : Icon(Icons.arrow_back_ios, size: SizeConfig.resizeHeight(30),),
                ),
                onPressed: (){
                  setState((){
                    _iscollapsed = !_iscollapsed;
                  });
                },
              ),
              actions: <Widget>[ //close
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.clear,color: Colors.white,size: SizeConfig.resizeHeight(30),), 
                    onPressed: (){
                      //model.logout();
                      Navigator.pushNamedAndRemoveUntil(context, LogIn.route ,  (Route<dynamic> route) => false);
                    } //BUTTON TO LOG OUT FROM THE APPBAR ANC CLEAN ALL ROUTES IN THE STACK
              ),
                )],  
            ),
            resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
            body: Builder(
              builder: (BuildContext context) {
                scaffold = Scaffold.of(context);
                return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      setState((){
                        _iscollapsed = !_iscollapsed;
                      });
                    }, 
                    child: MyDrawer(model: model,)),
                  myDashboard(context),
                ],);
              },),
          ),
        ),
      ),
    );
  }


  Widget myDashboard(context){ //this is where all lists are built
    return AnimatedPositioned(
      top: _iscollapsed ? 0 : 0.1 * screenHeight,
      bottom: _iscollapsed ? 0 : 0.1 * screenHeight,
      left: _iscollapsed ? 0 : 0.7 * screenWidth,
      right: _iscollapsed ? 0 : -0.6 * screenWidth,
      duration: duration,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
        animationDuration: duration,
        elevation: 6.0,
        child: ListView( //where all lists are built
          padding: EdgeInsets.symmetric(vertical: 10.0),
            children: <Widget>[
              SizedBox(height: SizeConfig.resizeHeight(10)), //with this space we can put something on the top
              Padding(            //this are the carousel selectors
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(      //this are the carousel selectors
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _icons
                          .asMap()
                          .entries
                          .map((MapEntry map) => _buildIcon(map.key))
                          .toList(),
                    ),
                  ),
              SizedBox(height:SizeConfig.resizeHeight(10)),
              Center(            //linea debajo del menu horizontal 
                    child: Container(
                      width: SizeConfig.resizeWidth(390),
                      height: 2.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ), 
              SizedBox(height:SizeConfig.resizeHeight(10)),
              _maincarousel[
                  _mainCarouselIndex], //THIS IS THE PART TO SELECT THE MAINCAROUSEL VIEW
            ],
          ),
      ),
    );
  }



}



   