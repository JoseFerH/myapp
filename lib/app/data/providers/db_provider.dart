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
  CollectionReference get proveedoresRef =>
      _firestore.collection('proveedores');
  CollectionReference get materialesRef => _firestore.collection('materiales');
  CollectionReference get ventasRef => _firestore.collection('ventas');
  CollectionReference get costosFijosRef =>
      _firestore.collection('costosFijos');
  CollectionReference get configuracionRef =>
      _firestore.collection('configuracion');
  CollectionReference get notasRef => _firestore.collection('notas');
  CollectionReference get proyectosRef => _firestore.collection('proyectos');

  // Inicializar configuración de Firestore
  Future<void> inicializarDB() async {
    print("DBProvider: Inicializando base de datos");

    // Verificar que existe documento de configuración
    try {
      print("DBProvider: Verificando proyectos");
      final proyectos = await proyectosRef.limit(1).get();
      if (proyectos.docs.isEmpty) {
        print("DBProvider: Creando proyectos predeterminados");
        await _crearProyectosPredeterminados();
      }
      final configDoc = await configuracionRef.doc('config').get();
      print("DBProvider: Verificando configuración");

      if (!configDoc.exists) {
        print("DBProvider: Creando configuración por defecto");
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
      print("DBProvider: Verificando costos fijos");
      final costosFijos = await costosFijosRef.limit(1).get();
      if (costosFijos.docs.isEmpty) {
        print("DBProvider: Creando costos fijos predeterminados");
        // Crear costos fijos predeterminados
        await _crearCostosFijosPredeterminados();
      }

      // Verificar si hay materiales
      print("DBProvider: Verificando materiales");
      final materiales = await materialesRef.limit(1).get();
      if (materiales.docs.isEmpty) {
        print("DBProvider: Creando materiales de ejemplo");
        // Crear materiales de ejemplo
        await _crearMaterialesEjemplo();
      }

      print("DBProvider: Inicialización completada");
    } catch (e) {
      print('Error inicializando DB: $e');
      rethrow;
    }
  }

  Future<void> _crearProyectosPredeterminados() async {
    final proyectosPredeterminados = [
      {
        'nombre': 'Personal',
        'descripcion': 'Proyectos para uso personal',
        'activo': true,
      },
      {
        'nombre': 'Redes Sociales',
        'descripcion': 'Proyectos para publicar en redes sociales',
        'activo': true,
      },
      {
        'nombre': 'Decoración',
        'descripcion': 'Proyectos para decoración de espacios',
        'activo': true,
      },
      {
        'nombre': 'Regalo',
        'descripcion': 'Proyectos para regalar',
        'activo': true,
      },
    ];

    WriteBatch batch = _firestore.batch();
    for (var proyecto in proyectosPredeterminados) {
      DocumentReference docRef = proyectosRef.doc();
      batch.set(docRef, proyecto);
    }

    await batch.commit();
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

  // Crear materiales de ejemplo
  Future<void> _crearMaterialesEjemplo() async {
    // Ejemplo de proveedor
    final proveedorRef = proveedoresRef.doc();
    await proveedorRef.set({
      'nombre': 'Proveedor Ejemplo',
      'contacto': 'Juan Pérez',
      'telefono': '12345678',
      'email': 'ejemplo@gmail.com',
      'direccion': 'Ciudad de Guatemala',
      'productos': ['Hojas', 'Laminados'],
    });

    // Ejemplo de hoja
    await materialesRef.doc().set({
      'nombre': 'Hoja Estándar',
      'descripcion': 'Hoja de papel estándar para stickers',
      'tipo': 'hoja',
      'tipoHoja': 'normal',
      'tamano': 'Carta',
      'precioUnitario': 20.0,
      'cantidadDisponible': 50,
      'cantidadMinima': 10,
      'proveedorId': proveedorRef.id,
      'fechaCompra': Timestamp.now(),
    });

    // Ejemplo de laminado
    await materialesRef.doc().set({
      'nombre': 'Laminado Mate',
      'descripcion': 'Laminado mate para stickers',
      'tipo': 'laminado',
      'tipoLaminado': 'mate',
      'grosor': 'Normal',
      'precioUnitario': 15.0,
      'cantidadDisponible': 40,
      'cantidadMinima': 8,
      'proveedorId': proveedorRef.id,
      'fechaCompra': Timestamp.now(),
    });
  }

  // Método para generar un ID único para documentos
  String generarId() {
    return _firestore.collection('_').doc().id;
  }
}
