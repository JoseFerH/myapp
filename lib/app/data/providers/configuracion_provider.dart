import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/configuracion_model.dart';
import '../models/costo_fijo_model.dart';
import 'db_provider.dart';

class ConfiguracionProvider {
  final DBProvider _dbProvider = DBProvider();
  
  // Obtener configuración global
  Future<ConfiguracionModel> obtenerConfiguracion() async {
    try {
      final DocumentSnapshot doc = await _dbProvider.configuracionRef.doc('config').get();
      
      if (!doc.exists) {
        // Crear configuración por defecto si no existe
        ConfiguracionModel configDefault = ConfiguracionModel.defaultConfig();
        await _dbProvider.configuracionRef
            .doc('config')
            .set(configDefault.toMap());
            
        return configDefault;
      }
      
      return ConfiguracionModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error al obtener configuración: $e');
      rethrow;
    }
  }
  
  // Actualizar configuración
  Future<void> actualizarConfiguracion(ConfiguracionModel config) async {
    try {
      await _dbProvider.configuracionRef
          .doc('config')
          .update(config.toMap());
    } catch (e) {
      print('Error al actualizar configuración: $e');
      rethrow;
    }
  }
  
  // Obtener costos fijos
  Future<List<CostoFijoModel>> obtenerCostosFijos() async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.costosFijosRef
          .orderBy('nombre')
          .get();
          
      return snapshot.docs
          .map((doc) => CostoFijoModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener costos fijos: $e');
      rethrow;
    }
  }
  
  // Obtener un costo fijo específico por ID
  Future<CostoFijoModel> obtenerCostoFijoPorId(String id) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.costosFijosRef.doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Costo fijo no encontrado');
      }
      
      return CostoFijoModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error al obtener costo fijo: $e');
      rethrow;
    }
  }
  
  // Crear un nuevo costo fijo
  Future<String> crearCostoFijo(CostoFijoModel costoFijo) async {
    try {
      final docRef = _dbProvider.costosFijosRef.doc();
      costoFijo.id = docRef.id;
      
      await docRef.set(costoFijo.toMap());
      
      return docRef.id;
    } catch (e) {
      print('Error al crear costo fijo: $e');
      rethrow;
    }
  }
  
  // Actualizar un costo fijo existente
  Future<void> actualizarCostoFijo(CostoFijoModel costoFijo) async {
    try {
      await _dbProvider.costosFijosRef
          .doc(costoFijo.id)
          .update(costoFijo.toMap());
    } catch (e) {
      print('Error al actualizar costo fijo: $e');
      rethrow;
    }
  }
  
  // Eliminar un costo fijo
  Future<void> eliminarCostoFijo(String id) async {
    try {
      await _dbProvider.costosFijosRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar costo fijo: $e');
      rethrow;
    }
  }
  
  // Obtener suma de costos fijos activos
  Future<double> obtenerSumaCostosFijos() async {
    try {
      List<CostoFijoModel> costosFijos = await obtenerCostosFijos();
      
      // Filtrar solo los activos
      costosFijos = costosFijos.where((costo) => costo.activo).toList();
      
      // Sumar valores
      double total = costosFijos.fold(0, (sum, costo) => sum + costo.valor);
      
      return total;
    } catch (e) {
      print('Error al obtener suma de costos fijos: $e');
      rethrow;
    }
  }
  
  // Activar/desactivar un costo fijo
  Future<void> toggleCostoFijo(String id, bool activo) async {
    try {
      await _dbProvider.costosFijosRef
          .doc(id)
          .update({'activo': activo});
    } catch (e) {
      print('Error al cambiar estado de costo fijo: $e');
      rethrow;
    }
  }
}