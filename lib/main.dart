import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/db_provider.dart';


import 'app/data/services/cliente_service.dart';
import 'app/data/services/material_service.dart';
import 'app/data/services/venta_service.dart';
import 'app/controllers/registros_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Usar try-catch para manejar la posible excepción de app duplicada
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Si ocurre un error porque Firebase ya está inicializado, simplemente continuamos
    print('Firebase initialization error handled: $e');
    // No es necesario hacer nada más, ya que Firebase ya estaría inicializado
  }
  
  // Configurar Firestore (esto funcionará aunque Firebase ya esté inicializado)
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, 
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED
    );
  } catch (e) {
    print('Error configuring Firestore: $e');
    // Continuar a pesar del error
  }
  
  // Inicializar la base de datos 
  try {
    final dbProvider = DBProvider();
    await dbProvider.inicializarDB();
  } catch (e) {
    print('Error initializing DB: $e');
    // Continuar a pesar del error
  }
  // Al final de la función main(), antes de runApp:
  // Inicializar controladores y servicios esenciales
  Get.put(ClienteService(), permanent: true).init();
  Get.put(MaterialService(), permanent: true).init();
  Get.put(VentaService(), permanent: true).init();
  Get.put(RegistrosController(), permanent: true);

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