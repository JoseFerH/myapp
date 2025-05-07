import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cliente_model.dart';
import 'db_provider.dart';

class ClientesProvider {
  final DBProvider _dbProvider = DBProvider();
  
  // Obtener todos los clientes
  Future<List<ClienteModel>> obtenerClientes() async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.clientesRef
          .orderBy('nombre')
          .get();
          
      return snapshot.docs
          .map((doc) => ClienteModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener clientes: $e');
      rethrow;
    }
  }
  
  // Obtener un cliente específico por ID
  Future<ClienteModel> obtenerClientePorId(String id) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.clientesRef.doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Cliente no encontrado');
      }
      
      return ClienteModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error al obtener cliente: $e');
      rethrow;
    }
  }
  
  // Buscar clientes por nombre o zona
  Future<List<ClienteModel>> buscarClientes(String query) async {
    try {
      // Convertir a minúsculas para búsqueda case-insensitive
      String queryLower = query.toLowerCase();
      
      final QuerySnapshot snapshot = await _dbProvider.clientesRef.get();
      
      // Filtrar los resultados manualmente (Firestore no soporta búsquedas case-insensitive directamente)
      List<ClienteModel> clientes = snapshot.docs
          .map((doc) => ClienteModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .where((cliente) => 
              cliente.nombre.toLowerCase().contains(queryLower) ||
              cliente.zona.toLowerCase().contains(queryLower))
          .toList();
          
      return clientes;
    } catch (e) {
      print('Error al buscar clientes: $e');
      rethrow;
    }
  }
  
  // Crear un nuevo cliente
  Future<String> crearCliente(ClienteModel cliente) async {
    try {
      final docRef = _dbProvider.clientesRef.doc();
      cliente.id = docRef.id;
      
      await docRef.set(cliente.toMap());
      
      return docRef.id;
    } catch (e) {
      print('Error al crear cliente: $e');
      rethrow;
    }
  }
  
  // Actualizar un cliente existente
  Future<void> actualizarCliente(ClienteModel cliente) async {
    try {
      await _dbProvider.clientesRef
          .doc(cliente.id)
          .update(cliente.toMap());
    } catch (e) {
      print('Error al actualizar cliente: $e');
      rethrow;
    }
  }
  
  // Eliminar un cliente
  Future<void> eliminarCliente(String id) async {
    try {
      // Verificar si hay ventas asociadas
      final QuerySnapshot ventasSnapshot = await _dbProvider.ventasRef
          .where('clienteId', isEqualTo: id)
          .limit(1)
          .get();
          
      if (ventasSnapshot.docs.isNotEmpty) {
        throw Exception('No se puede eliminar el cliente porque tiene ventas asociadas');
      }
      
      await _dbProvider.clientesRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar cliente: $e');
      rethrow;
    }
  }
  
  // Obtener top clientes por total gastado
  Future<List<ClienteModel>> obtenerTopClientes(int limite) async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.clientesRef
          .orderBy('totalGastado', descending: true)
          .limit(limite)
          .get();
          
      return snapshot.docs
          .map((doc) => ClienteModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener top clientes: $e');
      rethrow;
    }
  }
  
  // Actualizar total gastado de un cliente
  Future<void> actualizarTotalGastado(String clienteId, double monto) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.clientesRef.doc(clienteId).get();
      
      if (!doc.exists) {
        throw Exception('Cliente no encontrado');
      }
      
      ClienteModel cliente = ClienteModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      cliente.totalGastado += monto;
      
      await _dbProvider.clientesRef
          .doc(clienteId)
          .update({'totalGastado': cliente.totalGastado});
    } catch (e) {
      print('Error al actualizar total gastado: $e');
      rethrow;
    }
  }
}