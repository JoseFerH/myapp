// lib/app/bindings/home_binding.dart

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // El HomeController coordina la navegación entre las distintas secciones
    // No necesita servicios específicos, solo gestiona el estado de navegación
    Get.lazyPut<HomeController>(() => HomeController());
  }
}