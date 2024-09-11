import '../app/views/add/add_view.dart';
import '../app/views/detail/details_view.dart';
import '../app/views/home/home_view.dart';
import 'package:get/get.dart';

class Routes {
  static const String home = '/home';
  static const String add = '/add';
  static const String details = '/details';
}

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.home, page: () => HomeView()
        // binding: HomeBinding(), // Create and uncomment once HomeBinding is created
        ),
    GetPage(
      name: Routes.add,
      page: () => AddView(),
      // binding: AddBinding(), // Create and uncomment once AddBinding is created
    ),
    GetPage(
      name: Routes.details,
      page: () => DetailsView(),
      // binding: DetailsBinding(), // Create and uncomment once DetailsBinding is created
    ),
  ];
}
