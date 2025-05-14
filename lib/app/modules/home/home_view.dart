// lib/app/modules/home/home_view.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/notas_controller.dart';
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
import '../../data/services/notas_service.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar servicios que se usarán
    _initServices();

    // Inicializar controladores
    _initControllers();

    // Lista de títulos para cada vista
    // final titles = [
    //   'Registros',
    //   'Visualización',
    //   'Calculadora',
    //   'Carrito',
    //   'Estadísticas',
    //   'Notas',
    // ];

    // Lista de títulos para cada vista
    final titles = [
      'PRUEBA 1',
      'PRUEBA 2',
      'PRUEBA 3',
      'PRUEBA 4',
      'PRUEBA 5',
      'PRUEBA 6',
    ];

    return CupertinoPageScaffold(
      // AppBar dinámico que cambia según la pestaña seleccionada
      navigationBar: CupertinoNavigationBar(
        // Botón de notas en la barra superior izquierda
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.doc_text_search, size: 22),
          onPressed: () async {
            // Verificar que NotasService está registrado
            if (!Get.isRegistered<NotasService>()) {
              // Si no está registrado, registrarlo e inicializarlo
              final service = Get.put(NotasService(), permanent: true);
              await service.init(); // Esperamos a que se inicialice
            } else {
              // Asegurar que las notas estén cargadas
              final service = Get.find<NotasService>();
              if (service.notas.isEmpty) {
                await service.cargarNotas();
              }
            }

            // Navegar a la vista de notas
            Get.toNamed('/notas');
          },
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
                  const CalculadoraView(),
                  const CarritoView(),
                  const VisualizacionView(),
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
  // Método para inicializar servicios en home_view.dart
  void _initServices() {
    if (!Get.isRegistered<CalculadoraService>()) {
      Get.put(CalculadoraService(), permanent: true);
    }

    if (!Get.isRegistered<CarritoService>()) {
      Get.put(CarritoService(), permanent: true);
    }

    if (!Get.isRegistered<ClienteService>()) {
      Get.put(ClienteService(), permanent: true);
    }

    if (!Get.isRegistered<MaterialService>()) {
      Get.put(MaterialService(), permanent: true);
    }

    if (!Get.isRegistered<VentaService>()) {
      Get.put(VentaService(), permanent: true);
    }

    if (!Get.isRegistered<EstadisticasService>()) {
      Get.put(EstadisticasService(), permanent: true);
    }

    // Inicializar NotasService
    if (!Get.isRegistered<NotasService>()) {
      // Registrar primero, y luego inicializar de manera no bloqueante
      final service = Get.put(NotasService(), permanent: true);
      // La inicialización se hará sin bloquear
      service.init(); // No usamos await
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
