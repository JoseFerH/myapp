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
      final QuerySnapshot snapshot = await _dbProvider.materialesRef
          .orderBy('nombre')
          .get();
          
      return _procesarDocumentosMateriales(snapshot.docs);
    } catch (e) {
      print('Error al obtener materiales: $e');
      rethrow;
    }
  }
  
  // Procesar documentos según su tipo
  List<MaterialModel> _procesarDocumentosMateriales(List<DocumentSnapshot> docs) {
    return docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String tipo = data['tipo'] ?? '';
      
      if (tipo == 'hoja') {
        return HojaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      } else if (tipo == 'laminado') {
        return LaminadoModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        return MaterialModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      }
    }).toList();
  }
  
  // Obtener un material específico por ID
  Future<MaterialModel> obtenerMaterialPorId(String id) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.materialesRef.doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Material no encontrado');
      }
      
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String tipo = data['tipo'] ?? '';
      
      if (tipo == 'hoja') {
        return HojaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      } else if (tipo == 'laminado') {
        return LaminadoModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        return MaterialModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      }
    } catch (e) {
      print('Error al obtener material: $e');
      rethrow;
    }
  }
  
  // Obtener materiales por tipo
  Future<List<MaterialModel>> obtenerMaterialesPorTipo(TipoMaterial tipo) async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.materialesRef
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
      final QuerySnapshot snapshot = await _dbProvider.materialesRef
          .where('tipo', isEqualTo: 'hoja')
          .orderBy('nombre')
          .get();
          
      return snapshot.docs
          .map((doc) => HojaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener hojas: $e');
      rethrow;
    }
  }
  
  // Obtener laminados
  Future<List<LaminadoModel>> obtenerLaminados() async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.materialesRef
          .where('tipo', isEqualTo: 'laminado')
          .orderBy('nombre')
          .get();
          
      return snapshot.docs
          .map((doc) => LaminadoModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener laminados: $e');
      rethrow;
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
      await _dbProvider.materialesRef
          .doc(material.id)
          .update(material.toMap());
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
      final DocumentSnapshot doc = await _dbProvider.materialesRef.doc(materialId).get();
      
      if (!doc.exists) {
        throw Exception('Material no encontrado');
      }
      
      MaterialModel material = MaterialModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      
      if (material.cantidadDisponible < cantidad) {
        throw Exception('Stock insuficiente');
      }
      
      material.cantidadDisponible -= cantidad;
      
      await _dbProvider.materialesRef
          .doc(materialId)
          .update({'cantidadDisponible': material.cantidadDisponible});
    } catch (e) {
      print('Error al reducir stock: $e');
      rethrow;
    }
  }
  
  // Actualizar inventario (aumentar stock)
  Future<void> aumentarStock(String materialId, int cantidad) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.materialesRef.doc(materialId).get();
      
      if (!doc.exists) {
        throw Exception('Material no encontrado');
      }
      
      MaterialModel material = MaterialModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      material.cantidadDisponible += cantidad;
      
      await _dbProvider.materialesRef
          .doc(materialId)
          .update({'cantidadDisponible': material.cantidadDisponible});
    } catch (e) {
      print('Error al aumentar stock: $e');
      rethrow;
    }
  }
  
  // Obtener materiales con bajo stock
  Future<List<MaterialModel>> obtenerMaterialesBajoStock() async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.materialesRef.get();
      
      List<MaterialModel> materiales = _procesarDocumentosMateriales(snapshot.docs);
      
      return materiales.where((material) => material.esBajoStock).toList();
    } catch (e) {
      print('Error al obtener materiales bajo stock: $e');
      rethrow;
    }
  }
}