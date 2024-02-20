import 'package:get/get.dart';
import 'package:weatherapp/connectivity/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    //by using get.put im injecting NetworkController class into getx exviroment
  }
}
