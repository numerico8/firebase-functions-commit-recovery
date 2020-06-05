

import 'package:pimpineo_v1/services/firestore_service.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';

class TermsAndCondVM extends BaseModel{

FirestoreService _firestoreService = locator<FirestoreService>();

Future<String> getTermsAndConditions() async{
  String result;
  result = await _firestoreService.getTermsAndConditions();
  return result;
}


}