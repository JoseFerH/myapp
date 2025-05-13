// lib/app/routes/app_pages.dart

import 'package:get/get.dart';

// Importación de todos los bindings
import '../bindings/home_binding.dart';
import '../bindings/calculadora_binding.dart';
import '../bindings/carrito_binding.dart';
import '../bindings/configuracion_binding.dart';
import '../bindings/estadisticas_binding.dart';
import '../bindings/registros_binding.dart';
import '../bindings/visualizacion_binding.dart';

// Importación de todas las vistas
import '../modules/home/home_view.dart';
import '../modules/calculadora/calculadora_view.dart';
import '../modules/carrito/carrito_view.dart';
import '../modules/configuracion/configuracion_view.dart';
import '../modules/estadisticas/estadisticas_view.dart';
import '../modules/registros/registros_view.dart';
import '../modules/registros/views/clientes_view.dart';
import '../modules/registros/views/proveedores_view.dart';
import '../modules/registros/views/inventario_view.dart';
import '../modules/visualizacion/visualizacion_view.dart';

// Importación de las rutas
import 'app_routes.dart';

class AppPages {
  // Definición de la ruta inicial al abrir la aplicación
  static const INITIAL = AppRoutes.HOME;

  // Definición de todas las rutas con sus vistas y bindings correspondientes
  static final routes = [
    // Ruta principal que contiene el bottom navigation bar
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        // Rutas principales para las secciones del bottom navigation
        GetPage(
          // Asegurarse de que el nombre comience con '/'
          name: '/' + AppRoutes.CALCULADORA.replaceFirst('/', ''),
          page: () => const CalculadoraView(),
          binding: CalculadoraBinding(),
        ),
        GetPage(
          // Asegurarse de que el nombre comience con '/'
          name: '/' + AppRoutes.CARRITO.replaceFirst('/', ''),
          page: () => const CarritoView(),
          binding: CarritoBinding(),
        ),
        GetPage(
          // Asegurarse de que el nombre comience con '/'
          name: '/' + AppRoutes.REGISTROS.replaceFirst('/', ''),
          page: () => const RegistrosView(),
          binding: RegistrosBinding(),
          children: [
            // Sub-rutas para registros
            GetPage(
              // Asegurarse de que el nombre comience con '/'
              name: '/' + AppRoutes.CLIENTES.split('/').last,
              page: () => const ClientesView(),
            ),
            GetPage(
              // Asegurarse de que el nombre comience con '/'
              name: '/' + AppRoutes.PROVEEDORES.split('/').last,
              page: () => const ProveedoresView(),
            ),
            GetPage(
              // Asegurarse de que el nombre comience con '/'
              name: '/' + AppRoutes.INVENTARIO.split('/').last,
              page: () => const InventarioView(),
            ),
          ],
        ),
        GetPage(
          // Asegurarse de que el nombre comience con '/'
          name: '/' + AppRoutes.VISUALIZACION.replaceFirst('/', ''),
          page: () => const VisualizacionView(),
          binding: VisualizacionBinding(),
        ),
        GetPage(
          // Asegurarse de que el nombre comience con '/'
          name: '/' + AppRoutes.ESTADISTICAS.replaceFirst('/', ''),
          page: () => const EstadisticasView(),
          binding: EstadisticasBinding(),
        ),
        GetPage(
          // Asegurarse de que el nombre comience con '/'
          name: '/' + AppRoutes.CONFIGURACION.replaceFirst('/', ''),
          page: () => const ConfiguracionView(),
          binding: ConfiguracionBinding(),
        ),
      ],
    ),
    
    // Rutas directas (sin necesidad de estar anidadas) para navegación más sencilla
    GetPage(
      name: AppRoutes.CALCULADORA,
      page: () => const CalculadoraView(),
      binding: CalculadoraBinding(),
    ),
    GetPage(
      name: AppRoutes.CARRITO,
      page: () => const CarritoView(),
      binding: CarritoBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTROS,
      page: () => const RegistrosView(),
      binding: RegistrosBinding(),
    ),
    GetPage(
      name: AppRoutes.VISUALIZACION,
      page: () => const VisualizacionView(),
      binding: VisualizacionBinding(),
    ),
    GetPage(
      name: AppRoutes.ESTADISTICAS,
      page: () => const EstadisticasView(),
      binding: EstadisticasBinding(),
    ),
    GetPage(
      name: AppRoutes.CONFIGURACION,
      page: () => const ConfiguracionView(),
      binding: ConfiguracionBinding(),
    ),
  ];
}