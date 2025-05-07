import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Activar persistencia offline de Firestore
  await FirebaseFirestore.instance.settings = 
      Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  
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