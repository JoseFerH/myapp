// lib/app/controllers/home_controller.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'calculadora_controller.dart'; // Importar el controlador de calculadora

class HomeController extends GetxController {
  // Índice seleccionado para el bottom navigation bar
  final RxInt selectedIndex = 0.obs;

  // Lista de rutas correspondientes a cada índice del bottom navigation
  final List<String> routes = [
    AppRoutes.REGISTROS,
    AppRoutes.VISUALIZACION,
    AppRoutes.CALCULADORA,
    AppRoutes.CARRITO,
    AppRoutes.ESTADISTICAS,
  ];

  // Controlador para PageView (si se usa)
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Método para cambiar el índice seleccionado - MODIFICADO
  void changeIndex(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // NUEVO CÓDIGO: Si seleccionamos la pestaña de calculadora (índice 2),
    // actualizamos los datos de la calculadora para que use la configuración más reciente
    // if (index == 2) {
    //   try {
    //     final calculadoraController = Get.find<CalculadoraController>();
    //     calculadoraController.refrescarDatos();
    //   } catch (e) {
    //     print('Error al refrescar datos de calculadora: $e');
    //   }
    // }
  }

  // Método para navegar directamente a una ruta
  void navigateTo(String route) {
    int index = routes.indexOf(route);
    if (index != -1) {
      changeIndex(index);
    } else {
      Get.toNamed(route);
    }
  }
}
