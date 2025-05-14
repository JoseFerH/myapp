import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/material_model.dart';
import '../models/hoja_model.dart';
import '../models/laminado_model.dart';
import 'db_provider.dart';

class MaterialesProvider {
  final DBProvider _dbProvider = DBProvider();

  // Obtener todos los materiales
  Future<List<MaterialModel>> obtenerMateriales() async {
    try {
      final QuerySnapshot snapshot =
          await _dbProvider.materialesRef.orderBy('nombre').get();

      return _procesarDocumentosMateriales(snapshot.docs);
    } catch (e) {
      print('Error al obtener materiales: $e');
      rethrow;
    }
  }

  // Procesar documentos según su tipo
  List<MaterialModel> _procesarDocumentosMateriales(
    List<DocumentSnapshot> docs,
  ) {
    return docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String tipo = data['tipo'] ?? '';

      if (tipo == 'hoja') {
        return HojaModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      } else if (tipo == 'laminado') {
        return LaminadoModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      } else {
        return MaterialModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      }
    }).toList();
  }

  // Obtener un material específico por ID
  Future<MaterialModel> obtenerMaterialPorId(String id) async {
    try {
      final DocumentSnapshot doc =
          await _dbProvider.materialesRef.doc(id).get();

      if (!doc.exists) {
        throw Exception('Material no encontrado');
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String tipo = data['tipo'] ?? '';

      if (tipo == 'hoja') {
        return HojaModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      } else if (tipo == 'laminado') {
        return LaminadoModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      } else {
        return MaterialModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      }
    } catch (e) {
      print('Error al obtener material: $e');
      rethrow;
    }
  }

  // Obtener materiales por tipo
  Future<List<MaterialModel>> obtenerMaterialesPorTipo(
    TipoMaterial tipo,
  ) async {
    try {
      final QuerySnapshot snapshot =
          await _dbProvider.materialesRef
              .where('tipo', isEqualTo: tipo.toString().split('.').last)
              .orderBy('nombre')
              .get();

      return _procesarDocumentosMateriales(snapshot.docs);
    } catch (e) {
      print('Error al obtener materiales por tipo: $e');
      rethrow;
    }
  }

  // Obtener hojas
  Future<List<HojaModel>> obtenerHojas() async {
    try {
      print("MaterialesProvider: Buscando hojas en Firestore");

      // Consulta alternativa sin ordenamiento (para evitar necesidad de índice)
      final QuerySnapshot snapshot =
          await _dbProvider.materialesRef
              .where('tipo', isEqualTo: 'hoja')
              .get();

      print(
        "MaterialesProvider: Se encontraron ${snapshot.docs.length} documentos de hojas",
      );

      if (snapshot.docs.isEmpty) {
        print("MaterialesProvider: No hay hojas, creando una de ejemplo");

        // Crear hoja de ejemplo si no hay ninguna
        final hojaRef = _dbProvider.materialesRef.doc();
        final hoja = {
          'nombre': 'Hoja Estándar',
          'descripcion': 'Hoja de papel estándar para stickers',
          'tipo': 'hoja',
          'tipoHoja': 'normal',
          'tamano': 'Carta',
          'precioUnitario': 20.0,
          'cantidadDisponible': 50,
          'cantidadMinima': 10,
          'proveedorId': 'temp-provider-id',
          'fechaCompra': Timestamp.now(),
        };

        await hojaRef.set(hoja);

        // Crear un proveedor de ejemplo
        final proveedorRef = _dbProvider.proveedoresRef.doc();
        await proveedorRef.set({
          'nombre': 'Proveedor Ejemplo',
          'contacto': 'Juan Pérez',
          'telefono': '12345678',
          'email': 'ejemplo@gmail.com',
          'direccion': 'Ciudad de Guatemala',
          'productos': ['Hojas', 'Laminados'],
        });

        // Actualizar el proveedorId en la hoja
        await hojaRef.update({'proveedorId': proveedorRef.id});

        // Intentar obtener la hoja recién creada
        return [
          HojaModel(
            id: hojaRef.id,
            nombre: 'Hoja Estándar',
            descripcion: 'Hoja de papel estándar para stickers',
            precioUnitario: 20.0,
            cantidadDisponible: 50,
            cantidadMinima: 10,
            proveedorId: proveedorRef.id,
            fechaCompra: DateTime.now(),
            tipoHoja: TipoHoja.normal,
            tamano: 'Carta',
          ),
        ];
      }

      List<HojaModel> result =
          snapshot.docs.map((doc) {
            print(
              "MaterialesProvider: Convirtiendo documento ${doc.id} a HojaModel",
            );
            try {
              return HojaModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              );
            } catch (e) {
              print(
                "MaterialesProvider ERROR: Error al convertir documento a HojaModel: $e",
              );
              // Crear una hoja por defecto si hay error de conversión
              return HojaModel(
                id: doc.id,
                nombre: doc['nombre'] ?? 'Error de conversión',
                descripcion: doc['descripcion'] ?? 'Error al cargar datos',
                precioUnitario: (doc['precioUnitario'] ?? 0.0).toDouble(),
                cantidadDisponible: doc['cantidadDisponible'] ?? 0,
                cantidadMinima: doc['cantidadMinima'] ?? 0,
                proveedorId: doc['proveedorId'] ?? '',
                fechaCompra:
                    (doc['fechaCompra'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
                tipoHoja: TipoHoja.normal,
                tamano: doc['tamano'] ?? 'Desconocido',
              );
            }
          }).toList();

      return result;
    } catch (e) {
      print('Error al obtener hojas: $e');

      // En caso de error, devolver al menos una hoja de ejemplo
      print("MaterialesProvider: Devolviendo hoja de ejemplo por error");
      return [
        HojaModel(
          id: 'ejemplo-error-id',
          nombre: 'Hoja de Ejemplo (Error)',
          descripcion: 'Creada por error en la consulta',
          precioUnitario: 20.0,
          cantidadDisponible: 50,
          cantidadMinima: 10,
          proveedorId: 'ejemplo-proveedor-id',
          fechaCompra: DateTime.now(),
          tipoHoja: TipoHoja.normal,
          tamano: 'Carta',
        ),
      ];
    }
  }

  // Obtener laminados
  Future<List<LaminadoModel>> obtenerLaminados() async {
    try {
      print("MaterialesProvider: Buscando laminados en Firestore");

      // Consulta alternativa sin ordenamiento
      final QuerySnapshot snapshot =
          await _dbProvider.materialesRef
              .where('tipo', isEqualTo: 'laminado')
              .get();

      print(
        "MaterialesProvider: Se encontraron ${snapshot.docs.length} documentos de laminados",
      );

      if (snapshot.docs.isEmpty) {
        print("MaterialesProvider: No hay laminados, creando uno de ejemplo");

        // Crear laminado de ejemplo
        final laminadoRef = _dbProvider.materialesRef.doc();
        final laminado = {
          'nombre': 'Laminado Mate',
          'descripcion': 'Laminado mate para stickers',
          'tipo': 'laminado',
          'tipoLaminado': 'mate',
          'grosor': 'Normal',
          'precioUnitario': 15.0,
          'cantidadDisponible': 40,
          'cantidadMinima': 8,
          'proveedorId': 'temp-provider-id',
          'fechaCompra': Timestamp.now(),
        };

        await laminadoRef.set(laminado);

        // Intentar obtener el laminado recién creado
        return [
          LaminadoModel(
            id: laminadoRef.id,
            nombre: 'Laminado Mate',
            descripcion: 'Laminado mate para stickers',
            precioUnitario: 15.0,
            cantidadDisponible: 40,
            cantidadMinima: 8,
            proveedorId: 'temp-provider-id',
            fechaCompra: DateTime.now(),
            tipoLaminado: TipoLaminado.mate,
            grosor: 'Normal',
          ),
        ];
      }

      List<LaminadoModel> result =
          snapshot.docs.map((doc) {
            print(
              "MaterialesProvider: Convirtiendo documento ${doc.id} a LaminadoModel",
            );
            try {
              return LaminadoModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              );
            } catch (e) {
              print(
                "MaterialesProvider ERROR: Error al convertir documento a LaminadoModel: $e",
              );
              // Crear un laminado por defecto si hay error de conversión
              return LaminadoModel(
                id: doc.id,
                nombre: doc['nombre'] ?? 'Error de conversión',
                descripcion: doc['descripcion'] ?? 'Error al cargar datos',
                precioUnitario: (doc['precioUnitario'] ?? 0.0).toDouble(),
                cantidadDisponible: doc['cantidadDisponible'] ?? 0,
                cantidadMinima: doc['cantidadMinima'] ?? 0,
                proveedorId: doc['proveedorId'] ?? '',
                fechaCompra:
                    (doc['fechaCompra'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
                tipoLaminado: TipoLaminado.mate,
                grosor: doc['grosor'] ?? 'Normal',
              );
            }
          }).toList();

      return result;
    } catch (e) {
      print('Error al obtener laminados: $e');

      // En caso de error, devolver al menos un laminado de ejemplo
      print("MaterialesProvider: Devolviendo laminado de ejemplo por error");
      return [
        LaminadoModel(
          id: 'ejemplo-error-id',
          nombre: 'Laminado de Ejemplo (Error)',
          descripcion: 'Creado por error en la consulta',
          precioUnitario: 15.0,
          cantidadDisponible: 40,
          cantidadMinima: 8,
          proveedorId: 'ejemplo-proveedor-id',
          fechaCompra: DateTime.now(),
          tipoLaminado: TipoLaminado.mate,
          grosor: 'Normal',
        ),
      ];
    }
  }

  // Crear una nueva hoja
  Future<String> crearHoja(HojaModel hoja) async {
    try {
      final docRef = _dbProvider.materialesRef.doc();
      hoja.id = docRef.id;

      await docRef.set(hoja.toMap());

      return docRef.id;
    } catch (e) {
      print('Error al crear hoja: $e');
      rethrow;
    }
  }

  // Crear un nuevo laminado
  Future<String> crearLaminado(LaminadoModel laminado) async {
    try {
      final docRef = _dbProvider.materialesRef.doc();
      laminado.id = docRef.id;

      await docRef.set(laminado.toMap());

      return docRef.id;
    } catch (e) {
      print('Error al crear laminado: $e');
      rethrow;
    }
  }

  // Actualizar un material existente
  Future<void> actualizarMaterial(MaterialModel material) async {
    try {
      await _dbProvider.materialesRef.doc(material.id).update(material.toMap());
    } catch (e) {
      print('Error al actualizar material: $e');
      rethrow;
    }
  }

  // Eliminar un material
  Future<void> eliminarMaterial(String id) async {
    try {
      await _dbProvider.materialesRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar material: $e');
      rethrow;
    }
  }

  // Actualizar inventario (reducir stock)
  Future<void> reducirStock(String materialId, int cantidad) async {
    try {
      final DocumentSnapshot doc =
          await _dbProvider.materialesRef.doc(materialId).get();

      if (!doc.exists) {
        throw Exception('Material no encontrado');
      }

      MaterialModel material = MaterialModel.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>,
      );

      if (material.cantidadDisponible < cantidad) {
        throw Exception('Stock insuficiente');
      }

      material.cantidadDisponible -= cantidad;

      await _dbProvider.materialesRef.doc(materialId).update({
        'cantidadDisponible': material.cantidadDisponible,
      });
    } catch (e) {
      print('Error al reducir stock: $e');
      rethrow;
    }
  }

  // Actualizar inventario (aumentar stock)
  Future<void> aumentarStock(String materialId, int cantidad) async {
    try {
      final DocumentSnapshot doc =
          await _dbProvider.materialesRef.doc(materialId).get();

      if (!doc.exists) {
        throw Exception('Material no encontrado');
      }

      MaterialModel material = MaterialModel.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>,
      );
      material.cantidadDisponible += cantidad;

      await _dbProvider.materialesRef.doc(materialId).update({
        'cantidadDisponible': material.cantidadDisponible,
      });
    } catch (e) {
      print('Error al aumentar stock: $e');
      rethrow;
    }
  }

  // Obtener materiales con bajo stock
  Future<List<MaterialModel>> obtenerMaterialesBajoStock() async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.materialesRef.get();

      List<MaterialModel> materiales = _procesarDocumentosMateriales(
        snapshot.docs,
      );

      return materiales.where((material) => material.esBajoStock).toList();
    } catch (e) {
      print('Error al obtener materiales bajo stock: $e');
      rethrow;
    }
  }
}
