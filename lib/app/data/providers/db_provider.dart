import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DBProvider {
  // Singleton pattern
  static final DBProvider _instance = DBProvider._internal();
  factory DBProvider() => _instance;
  DBProvider._internal();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Referencias a colecciones principales
  CollectionReference get clientesRef => _firestore.collection('clientes');
  CollectionReference get proveedoresRef => _firestore.collection('proveedores');
  CollectionReference get materialesRef => _firestore.collection('materiales');
  CollectionReference get ventasRef => _firestore.collection('ventas');
  CollectionReference get costosFijosRef => _firestore.collection('costosFijos');
  CollectionReference get configuracionRef => _firestore.collection('configuracion');
  
  // Inicializar configuración de Firestore
  Future<void> inicializarDB() async {
    // Configurar índices y cache si es necesario
    await _firestore.settings.persistenceEnabled;
    
    // Verificar que existe documento de configuración
    try {
      final configDoc = await configuracionRef.doc('config').get();
      if (!configDoc.exists) {
        // Crear configuración por defecto si no existe
        await configuracionRef.doc('config').set({
          'porcentajeGananciasMin': 50.0,
          'porcentajeGananciasDefault': 50.0,
          'precioDisenioEstandar': 0.0,
          'precioDisenioPersonalizado': 50.0,
          'costoEnvioNormal': 18.0,
          'costoEnvioExpress': 30.0,
          'aplicarDesperdicioDefault': true,
          'porcentajeDesperdicio': 5.0,
          'precioCuartoHoja': 20.0,
          'precioMediaHoja': 15.0,
          'precioRedesSociales': 90.0,
          'precioMayorista': 10.0,
          'cantidadMayorista': 100,
        });
      }
      
      // Verificar si existen costos fijos predeterminados
      final costosFijos = await costosFijosRef.limit(1).get();
      if (costosFijos.docs.isEmpty) {
        // Crear costos fijos predeterminados
        await _crearCostosFijosPredeterminados();
      }
      
    } catch (e) {
      print('Error inicializando DB: $e');
      rethrow;
    }
  }
  
  // Crear costos fijos predeterminados
  Future<void> _crearCostosFijosPredeterminados() async {
    final costosFijos = [
      {
        'nombre': 'Cricut',
        'descripcion': 'Desgaste de la máquina Cricut',
        'valor': 5.0,
        'activo': true,
      },
      {
        'nombre': 'Mat de Corte',
        'descripcion': 'Desgaste del mat de corte',
        'valor': 2.0,
        'activo': true,
      },
      {
        'nombre': 'Cuchilla de corte',
        'descripcion': 'Desgaste de la cuchilla de corte',
        'valor': 1.5,
        'activo': true,
      },
      {
        'nombre': 'Apple Pencil',
        'descripcion': 'Desgaste de punta Apple Pencil',
        'valor': 1.0,
        'activo': true,
      },
      {
        'nombre': 'Empaque de Stickers',
        'descripcion': 'Costo por empaque de stickers',
        'valor': 3.0,
        'activo': true,
      },
      {
        'nombre': 'Postales de Empaque',
        'descripcion': 'Tarjetas promocionales en empaque',
        'valor': 1.0,
        'activo': true,
      },
    ];
    
    WriteBatch batch = _firestore.batch();
    for (var costo in costosFijos) {
      DocumentReference docRef = costosFijosRef.doc();
      batch.set(docRef, costo);
    }
    
    await batch.commit();
  }
  
  // Método para generar un ID único para documentos
  String generarId() {
    return _firestore.collection('_').doc().id;
  }
}