import 'package:digidastavej/app/bindings/bindings.dart';

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
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.add,
      page: () => AddView(),
      binding: AddBinding(),
    ),
    GetPage(
      name: Routes.details,
      page: () => DetailsView(),
      binding: DetailsBinding(),
    ),
  ];
}
