import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart'; // Importar para SystemChrome
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/db_provider.dart';
import 'app/data/services/calculadora_service.dart';
import 'app/data/services/carrito_service.dart';
import 'app/data/services/cliente_service.dart';
import 'app/data/services/material_service.dart';
import 'app/data/services/venta_service.dart';
import 'app/data/services/pdf_service.dart';
import 'app/data/services/exportacion_service.dart';
import 'app/data/services/estadisticas_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación según el tipo de dispositivo
  _setOrientationConstraints();

  // Inicializar Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error handled: $e');
  }

  // Configure Firestore
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    print('Error configuring Firestore: $e');
  }

  // Initialize database
  try {
    final dbProvider = DBProvider();
    await dbProvider.inicializarDB();
  } catch (e) {
    print('Error initializing DB: $e');
  }

  // Pre-register essential services
  final calculadoraService = await CalculadoraService().init();
  final carritoService = await CarritoService().init();
  final clienteService = await ClienteService().init();
  final materialService = await MaterialService().init();
  final ventaService = await VentaService().init();
  final pdfService = PDFService();
  final exportacionService = ExportacionService();
  final estadisticasService = await EstadisticasService().init();

  // Register all services with GetX
  Get.put(calculadoraService, permanent: true);
  Get.put(carritoService, permanent: true);
  Get.put(clienteService, permanent: true);
  Get.put(materialService, permanent: true);
  Get.put(ventaService, permanent: true);
  Get.put(pdfService, permanent: true);
  Get.put(exportacionService, permanent: true);
  Get.put(estadisticasService, permanent: true);

  runApp(
    GetCupertinoApp(
      title: "Creati Calculator",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: const CupertinoThemeData(
        primaryColor: Color(0xFF007AFF),
        brightness: Brightness.light,
      ),
    ),
  );
}

// Función para determinar la orientación según el tipo de dispositivo
void _setOrientationConstraints() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Obtener información del tamaño de la pantalla
    final mediaQuery = MediaQueryData.fromView(WidgetsBinding.instance.window);
    final screenSize = mediaQuery.size;
    final shortestSide = screenSize.shortestSide;

    // Considerar como tablet si el lado más corto es mayor a 600dp
    // Esta es una métrica comúnmente usada para determinar si es tablet
    final isTablet = shortestSide >= 600;

    if (isTablet) {
      // Para tablets: permitir todas las orientaciones
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Para teléfonos: bloquear solo en modo vertical (portrait)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  });
}
