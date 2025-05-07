// lib/app/modules/home/home_view.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import 'components/bottom_nav_bar.dart';
import '../../modules/calculadora/calculadora_view.dart';
import '../../modules/carrito/carrito_view.dart';
import '../../modules/configuracion/configuracion_view.dart';
import '../../modules/estadisticas/estadisticas_view.dart';
import '../../modules/registros/registros_view.dart';
import '../../modules/visualizacion/visualizacion_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de vistas para el PageView
    final pages = [
      const RegistrosView(),
      const VisualizacionView(),
      const CalculadoraView(),
      const CarritoView(),
      const EstadisticasView(),
    ];

    // Lista de títulos para cada vista
    final titles = [
      'Registros',
      'Visualización',
      'Calculadora',
      'Carrito',
      'Estadísticas',
    ];

    return CupertinoPageScaffold(
      // AppBar dinámico que cambia según la pestaña seleccionada
      navigationBar: CupertinoNavigationBar(
        middle: Obx(() => Text(titles[controller.selectedIndex.value])),
        // Botón de configuración en la barra superior
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.settings, size: 22),
          onPressed: () => Get.toNamed('/configuracion'),
        ),
      ),
      child: SafeArea(
        // Estructura principal con PageView y BottomNavigationBar
        child: Column(
          children: [
            // PageView que ocupa la mayor parte de la pantalla
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(), // Desactivar deslizamiento manual
                onPageChanged: controller.changeIndex,
                children: pages,
              ),
            ),
            // Bottom Navigation Bar
            const BottomNavBar(),
          ],
        ),
      ),
    );
  }
}