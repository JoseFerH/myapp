import 'package:get/get.dart';
import '../controllers/calculadora_controller.dart';
import '../data/services/calculadora_service.dart';
import '../data/services/carrito_service.dart';

class CalculadoraBinding implements Bindings {
  @override
  void dependencies() {
    // Asegurarse de que los servicios estén disponibles
    if (!Get.isRegistered<CalculadoraService>()) {
      Get.put(CalculadoraService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<CarritoService>()) {
      Get.put(CarritoService().init(), permanent: true);
    }
    
    // Inyectar el controlador
    Get.lazyPut<CalculadoraController>(() => CalculadoraController());
  }
}