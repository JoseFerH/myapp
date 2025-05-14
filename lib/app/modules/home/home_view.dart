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

// Importar los controladores necesarios
import '../../controllers/calculadora_controller.dart';
import '../../controllers/carrito_controller.dart';
import '../../controllers/estadisticas_controller.dart';
import '../../controllers/registros_controller.dart';
import '../../controllers/visualizacion_controller.dart';

// Importar los servicios necesarios
import '../../data/services/calculadora_service.dart';
import '../../data/services/carrito_service.dart';
import '../../data/services/cliente_service.dart';
import '../../data/services/material_service.dart';
import '../../data/services/venta_service.dart';
import '../../data/services/estadisticas_service.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar servicios que se usarán
    _initServices();

    // Inicializar controladores
    _initControllers();

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
        // Botón de notas en la barra superior izquierda
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.doc_text_search, size: 22),
          onPressed: () => Get.toNamed('/notas'),
        ),
        middle: Obx(() => Text(titles[controller.selectedIndex.value])),
        // Botón de configuración en la barra superior derecha
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
                physics:
                    const NeverScrollableScrollPhysics(), // Desactivar deslizamiento manual
                onPageChanged: controller.changeIndex,
                children: [
                  const RegistrosView(),
                  const VisualizacionView(),
                  const CalculadoraView(),
                  const CarritoView(),
                  const EstadisticasView(),
                ],
              ),
            ),
            // Bottom Navigation Bar
            const BottomNavBar(),
          ],
        ),
      ),
    );
  }

  // Método para inicializar servicios
  void _initServices() {
    if (!Get.isRegistered<CalculadoraService>()) {
      Get.put(CalculadoraService().init(), permanent: true);
    }

    if (!Get.isRegistered<CarritoService>()) {
      Get.put(CarritoService().init(), permanent: true);
    }

    if (!Get.isRegistered<ClienteService>()) {
      Get.put(ClienteService().init(), permanent: true);
    }

    if (!Get.isRegistered<MaterialService>()) {
      Get.put(MaterialService().init(), permanent: true);
    }

    if (!Get.isRegistered<VentaService>()) {
      Get.put(VentaService().init(), permanent: true);
    }

    if (!Get.isRegistered<EstadisticasService>()) {
      Get.put(EstadisticasService().init(), permanent: true);
    }
  }

  // Método para inicializar controladores
  void _initControllers() {
    if (!Get.isRegistered<CalculadoraController>()) {
      Get.put(CalculadoraController());
    }

    if (!Get.isRegistered<CarritoController>()) {
      Get.put(CarritoController());
    }

    if (!Get.isRegistered<RegistrosController>()) {
      Get.put(RegistrosController());
    }

    if (!Get.isRegistered<VisualizacionController>()) {
      Get.put(VisualizacionController());
    }

    if (!Get.isRegistered<EstadisticasController>()) {
      Get.put(EstadisticasController());
    }
  }
}
