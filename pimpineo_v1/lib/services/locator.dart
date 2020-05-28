import 'package:get_it/get_it.dart';
import 'package:pimpineo_v1/services/animation_service.dart';
import 'package:pimpineo_v1/services/authentication.dart';
import 'package:pimpineo_v1/services/firestore_service.dart';
import 'package:pimpineo_v1/services/validator.dart';
import 'package:pimpineo_v1/viewmodels/comprar_credito_model.dart';
import 'package:pimpineo_v1/viewmodels/contacts_viewmodel.dart';
import 'package:pimpineo_v1/viewmodels/login_viewmodel.dart';
import 'package:pimpineo_v1/viewmodels/registrarse_us_view_model.dart';
import 'package:pimpineo_v1/viewmodels/tarjeta_credito_model.dart';
import 'package:pimpineo_v1/viewmodels/us_lobby_model.dart';

GetIt locator = GetIt.instance;    //locator uses the package get it that is used to get and inject classes into other classes

void setuplocator(){

  // ViewModels
  locator.registerFactory(() => USLobbyModel());
  locator.registerFactory(() => ContactsViewModel());
  

  //unique instances 
  locator.registerLazySingleton(() => LogInModel());
  locator.registerLazySingleton(() => RegistrarseViewModel());
  locator.registerLazySingleton(() => ComprarCreditoModel());
  locator.registerLazySingleton(() => TarjetaCreditoModel());
  

  // Services unique instances
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => UserValidator());
  locator.registerFactory(() => AnimationService());
  
  
  
}