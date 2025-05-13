import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final calculadoraService = CalculadoraService();
  final carritoService = CarritoService();
  final clienteService = ClienteService();
  final materialService = MaterialService();
  final ventaService = VentaService();
  final pdfService = PDFService();
  final exportacionService = ExportacionService();
  final estadisticasService = EstadisticasService();

  // Register all services with GetX
  Get.put(calculadoraService, permanent: true);
  Get.put(carritoService, permanent: true);
  Get.put(clienteService, permanent: true);
  Get.put(materialService, permanent: true);
  Get.put(ventaService, permanent: true);
  Get.put(pdfService, permanent: true);
  Get.put(exportacionService, permanent: true);
  Get.put(estadisticasService, permanent: true);

  // Initialize services that require initialization
  calculadoraService.init();
  carritoService.init();
  clienteService.init();
  materialService.init();
  ventaService.init();
  estadisticasService.init();

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
