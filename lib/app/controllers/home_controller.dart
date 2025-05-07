// lib/app/controllers/home_controller.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

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
  
  // Método para cambiar el índice seleccionado
  void changeIndex(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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