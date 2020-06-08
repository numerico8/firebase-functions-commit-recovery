import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/view/launch_page.dart';
import 'package:pimpineo_v1/services/router.dart';
import 'package:provider/provider.dart';
import 'package:pimpineo_v1/services/providers.dart' as providers;
import 'package:pimpineo_v1/services/size_config.dart';
import 'package:pimpineo_v1/services/app_theme.dart';



void main(){
  setuplocator(); //here we declare the locator tha will help us to instanciate all the other classes and the view models
  WidgetsFlutterBinding.ensureInitialized(); //so you ensure that the app is initialized
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) //sets the device orientation to be only portrait 
  .then((_)=>runApp(MyApp())); //once it is loaded it runs the app since this is an async function.  
} 


class MyApp extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers.provider,
      child: LayoutBuilder(
        builder: (context, constraints){
          SizeConfig().init(constraints);
          return  MaterialApp(
            initialRoute: LaunchPage.route, //it can ve instantiated like that since is static variable
            onGenerateRoute: Router.generateRoute,
            debugShowCheckedModeBanner: false,
            title: 'Pimpineo',
            theme: AppTheme.theme,
            home: MyHomePage(title: 'Pimpineo'),
          );
        }
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    return LaunchPage();
  }

}
