// lib/app/bindings/carrito_binding.dart

import 'package:get/get.dart';
import '../controllers/carrito_controller.dart';
import '../data/services/carrito_service.dart';
import '../data/services/cliente_service.dart';
import '../data/services/pdf_service.dart';

class CarritoBinding implements Bindings {
  @override
  void dependencies() {
    // Servicios necesarios para el carrito
    if (!Get.isRegistered<CarritoService>()) {
      Get.put(CarritoService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<ClienteService>()) {
      Get.put(ClienteService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<PDFService>()) {
      Get.put(PDFService(), permanent: true);
    }
    
    // Inyectar el controlador
    Get.lazyPut<CarritoController>(() => CarritoController());
  }
}