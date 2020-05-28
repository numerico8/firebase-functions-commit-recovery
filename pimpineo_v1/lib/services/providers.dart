import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/controllers.dart';
import 'package:pimpineo_v1/model/contactos_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';



List<SingleChildWidget> provider = [
  StreamProvider<User>(
      initialData: User.initial(),
      create: (context) => Controllers.userStreamController.stream,
  ),
  ChangeNotifierProvider<ListaContactosModel>(
    create: (context) => ListaContactosModel(),
  ),
];



//in case this list are needed we use it but so far we do not have so many providers that we are goint to really need this amount of providers list
// List<SingleChildWidget> independentServices = [];

// List<SingleChildWidget> dependentServices = [];

// List<SingleChildWidget> uiServices = [];