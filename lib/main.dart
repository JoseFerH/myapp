import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/db_provider.dart';
import 'app/data/services/calculadora_service.dart';
import 'app/data/services/carrito_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase con manejo de errores
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error handled: $e');
  }

  // Configurar Firestore
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    print('Error configuring Firestore: $e');
  }

  // Inicializar la base de datos
  try {
    final dbProvider = DBProvider();
    await dbProvider.inicializarDB();
  } catch (e) {
    print('Error initializing DB: $e');
  }

  // Pre-registrar servicios esenciales
  Get.put(CalculadoraService(), permanent: true);
  Get.put(CarritoService(), permanent: true);

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
