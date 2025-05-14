// lib/app/bindings/notas_binding.dart
import 'package:get/get.dart';
import '../controllers/notas_controller.dart';
import '../data/services/notas_service.dart';

class NotasBinding implements Bindings {
  @override
  void dependencies() {
    // Registrar el servicio si no está registrado
    if (!Get.isRegistered<NotasService>()) {
      Get.put(NotasService(), permanent: true);
    }

    // Registrar el controlador
    Get.put(NotasController());
  }
}
