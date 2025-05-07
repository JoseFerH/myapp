import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/proveedor_model.dart';
import 'db_provider.dart';

class ProveedoresProvider {
  final DBProvider _dbProvider = DBProvider();
  
  // Obtener todos los proveedores
  Future<List<ProveedorModel>> obtenerProveedores() async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.proveedoresRef
          .orderBy('nombre')
          .get();
          
      return snapshot.docs
          .map((doc) => ProveedorModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener proveedores: $e');
      rethrow;
    }
  }
  
  // Obtener un proveedor específico por ID
  Future<ProveedorModel> obtenerProveedorPorId(String id) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.proveedoresRef.doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Proveedor no encontrado');
      }
      
      return ProveedorModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error al obtener proveedor: $e');
      rethrow;
    }
  }
  
  // Buscar proveedores por nombre o producto
  Future<List<ProveedorModel>> buscarProveedores(String query) async {
    try {
      String queryLower = query.toLowerCase();
      
      final QuerySnapshot snapshot = await _dbProvider.proveedoresRef.get();
      
      List<ProveedorModel> proveedores = snapshot.docs
          .map((doc) => ProveedorModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .where((proveedor) => 
              proveedor.nombre.toLowerCase().contains(queryLower) ||
              proveedor.productos.any((producto) => producto.toLowerCase().contains(queryLower)))
          .toList();
          
      return proveedores;
    } catch (e) {
      print('Error al buscar proveedores: $e');
      rethrow;
    }
  }
  
  // Crear un nuevo proveedor
  Future<String> crearProveedor(ProveedorModel proveedor) async {
    try {
      final docRef = _dbProvider.proveedoresRef.doc();
      proveedor.id = docRef.id;
      
      await docRef.set(proveedor.toMap());
      
      return docRef.id;
    } catch (e) {
      print('Error al crear proveedor: $e');
      rethrow;
    }
  }
  
  // Actualizar un proveedor existente
  Future<void> actualizarProveedor(ProveedorModel proveedor) async {
    try {
      await _dbProvider.proveedoresRef
          .doc(proveedor.id)
          .update(proveedor.toMap());
    } catch (e) {
      print('Error al actualizar proveedor: $e');
      rethrow;
    }
  }
  
  // Eliminar un proveedor
  Future<void> eliminarProveedor(String id) async {
    try {
      // Verificar si hay materiales asociados
      final QuerySnapshot materialesSnapshot = await _dbProvider.materialesRef
          .where('proveedorId', isEqualTo: id)
          .limit(1)
          .get();
          
      if (materialesSnapshot.docs.isNotEmpty) {
        throw Exception('No se puede eliminar el proveedor porque tiene materiales asociados');
      }
      
      await _dbProvider.proveedoresRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar proveedor: $e');
      rethrow;
    }
  }
  
  // Agregar producto a un proveedor
  Future<void> agregarProducto(String proveedorId, String producto) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.proveedoresRef.doc(proveedorId).get();
      
      if (!doc.exists) {
        throw Exception('Proveedor no encontrado');
      }
      
      ProveedorModel proveedor = ProveedorModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      
      // Verificar si el producto ya existe
      if (!proveedor.productos.contains(producto)) {
        proveedor.productos.add(producto);
        
        await _dbProvider.proveedoresRef
            .doc(proveedorId)
            .update({'productos': proveedor.productos});
      }
    } catch (e) {
      print('Error al agregar producto: $e');
      rethrow;
    }
  }
  
  // Eliminar producto de un proveedor
  Future<void> eliminarProducto(String proveedorId, String producto) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.proveedoresRef.doc(proveedorId).get();
      
      if (!doc.exists) {
        throw Exception('Proveedor no encontrado');
      }
      
      ProveedorModel proveedor = ProveedorModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      
      proveedor.productos.remove(producto);
      
      await _dbProvider.proveedoresRef
          .doc(proveedorId)
          .update({'productos': proveedor.productos});
    } catch (e) {
      print('Error al eliminar producto: $e');
      rethrow;
    }
  }
}