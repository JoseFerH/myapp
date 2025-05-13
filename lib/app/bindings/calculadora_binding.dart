import 'package:get/get.dart';
import '../controllers/calculadora_controller.dart';
import '../data/services/calculadora_service.dart';
import '../data/services/carrito_service.dart';

class CalculadoraBinding implements Bindings {
  @override
  void dependencies() {
    // Registrar los servicios de forma inmediata
    if (!Get.isRegistered<CalculadoraService>()) {
      final calculadoraService = CalculadoraService();
      Get.put(calculadoraService, permanent: true);
      // Inicializar el servicio (sin await para no bloquear)
      calculadoraService.init();
    }

    if (!Get.isRegistered<CarritoService>()) {
      final carritoService = CarritoService();
      Get.put(carritoService, permanent: true);
      carritoService.init();
    }

    // Registrar el controlador después de los servicios
    Get.put(CalculadoraController());
  }
}
