// lib/app/data/providers/proyectos_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/proyecto_model.dart';
import 'db_provider.dart';

class ProyectosProvider {
  final DBProvider _dbProvider = DBProvider();

  // Obtener todos los proyectos
  Future<List<ProyectoModel>> obtenerProyectos() async {
    try {
      final QuerySnapshot snapshot =
          await _dbProvider.proyectosRef.orderBy('nombre').get();

      return snapshot.docs
          .map(
            (doc) => ProyectoModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      print('Error al obtener proyectos: $e');
      rethrow;
    }
  }

  // Obtener un proyecto específico por ID
  Future<ProyectoModel> obtenerProyectoPorId(String id) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.proyectosRef.doc(id).get();

      if (!doc.exists) {
        throw Exception('Proyecto no encontrado');
      }

      return ProyectoModel.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>,
      );
    } catch (e) {
      print('Error al obtener proyecto: $e');
      rethrow;
    }
  }

  // Crear un nuevo proyecto
  Future<String> crearProyecto(ProyectoModel proyecto) async {
    try {
      final docRef = _dbProvider.proyectosRef.doc();
      proyecto.id = docRef.id;

      await docRef.set(proyecto.toMap());

      return docRef.id;
    } catch (e) {
      print('Error al crear proyecto: $e');
      rethrow;
    }
  }

  // Actualizar un proyecto existente
  Future<void> actualizarProyecto(ProyectoModel proyecto) async {
    try {
      await _dbProvider.proyectosRef.doc(proyecto.id).update(proyecto.toMap());
    } catch (e) {
      print('Error al actualizar proyecto: $e');
      rethrow;
    }
  }

  // Eliminar un proyecto
  Future<void> eliminarProyecto(String id) async {
    try {
      await _dbProvider.proyectosRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar proyecto: $e');
      rethrow;
    }
  }

  // Activar/desactivar un proyecto
  Future<void> toggleProyecto(String id, bool activo) async {
    try {
      await _dbProvider.proyectosRef.doc(id).update({'activo': activo});
    } catch (e) {
      print('Error al cambiar estado de proyecto: $e');
      rethrow;
    }
  }
}
