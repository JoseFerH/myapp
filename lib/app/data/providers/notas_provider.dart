// lib/app/data/providers/notas_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/nota_model.dart';
import 'db_provider.dart';

class NotasProvider {
  final DBProvider _dbProvider = DBProvider();

  // Añadir referencia a colección en db_provider.dart
  CollectionReference get notasRef => _dbProvider.notasRef;

  // Obtener todas las notas
  Future<List<NotaModel>> obtenerNotas() async {
    try {
      final QuerySnapshot snapshot =
          await notasRef.orderBy('fechaModificacion', descending: true).get();

      return snapshot.docs
          .map(
            (doc) => NotaModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      print('Error al obtener notas: $e');
      rethrow;
    }
  }

  // Crear una nueva nota
  Future<String> crearNota(NotaModel nota) async {
    try {
      final docRef = notasRef.doc();
      nota.id = docRef.id;

      await docRef.set(nota.toMap());

      return docRef.id;
    } catch (e) {
      print('Error al crear nota: $e');
      rethrow;
    }
  }

  // Actualizar una nota
  Future<void> actualizarNota(NotaModel nota) async {
    try {
      await notasRef.doc(nota.id).update(nota.toMap());
    } catch (e) {
      print('Error al actualizar nota: $e');
      rethrow;
    }
  }

  // Eliminar una nota
  Future<void> eliminarNota(String id) async {
    try {
      await notasRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar nota: $e');
      rethrow;
    }
  }
}
