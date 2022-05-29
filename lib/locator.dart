import 'package:get_it/get_it.dart';
import 'package:myapp/controllers/AuctionTableGetItController.dart';
import 'package:myapp/controllers/UserController.dart';

GetIt getIt = GetIt.instance;

//SharedPreferences sharedPreferences;
setupLocators() {
  getIt.registerLazySingleton(() => UserController());
  getIt.registerLazySingleton(() => AuctionTableGetItController());
  
}

fetchCastPermissionType() {
  //getIt.registerLazySingleton(() => );
}
