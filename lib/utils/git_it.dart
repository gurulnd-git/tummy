import 'package:get_it/get_it.dart';
import 'package:yummy_tummy/utils/navigation_service.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  // locator.registerFactory<HomeModel>(() => HomeModel());
}
