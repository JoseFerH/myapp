// lib/app/bindings/notas_binding.dart
import 'package:get/get.dart';
import '../controllers/notas_controller.dart';
import '../data/services/notas_service.dart';

class NotasBinding implements Bindings {
  @override
  void dependencies() {
    // Servicios necesarios
    if (!Get.isRegistered<NotasService>()) {
      Get.put(NotasService().init(), permanent: true);
    }

    // Controlador
    Get.lazyPut<NotasController>(() => NotasController());
  }
}
