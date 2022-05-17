import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:myapp/Views/home_page.dart';
import 'package:myapp/Views/login_register_page.dart';
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
