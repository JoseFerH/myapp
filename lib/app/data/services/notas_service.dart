// lib/app/data/services/notas_service.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/nota_model.dart';
import '../providers/notas_provider.dart';

class NotasService extends GetxService {
  final NotasProvider _notasProvider = NotasProvider();

  // Rx Variables para el estado
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;

  // Rx Variable para lista de notas - inicializar como lista vacía
  final RxList<NotaModel> notas = <NotaModel>[].obs;

  // Constructor sin inicialización asincrónica
  NotasService() {
    print("NotasService inicializado sincrónicamente");
  }

  // Método para cargar datos iniciales
  Future<NotasService> init() async {
    await cargarNotas();
    return this;
  }

  // Cargar todas las notas
  Future<void> cargarNotas() async {
    try {
      cargando.value = true;
      error.value = '';

      List<NotaModel> listaNotas = await _notasProvider.obtenerNotas();
      notas.assignAll(listaNotas);
    } catch (e) {
      error.value = 'Error al cargar notas: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Crear nueva nota
  Future<String> crearNota(NotaModel nota) async {
    try {
      cargando.value = true;
      error.value = '';

      String id = await _notasProvider.crearNota(nota);

      // Actualizar lista local
      await cargarNotas();

      return id;
    } catch (e) {
      error.value = 'Error al crear nota: $e';
      print(error.value);
      return '';
    } finally {
      cargando.value = false;
    }
  }

  // Actualizar nota
  Future<bool> actualizarNota(NotaModel nota) async {
    try {
      cargando.value = true;
      error.value = '';

      await _notasProvider.actualizarNota(nota);

      // Actualizar lista local
      await cargarNotas();

      return true;
    } catch (e) {
      error.value = 'Error al actualizar nota: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  // Eliminar nota
  Future<bool> eliminarNota(String id) async {
    try {
      cargando.value = true;
      error.value = '';

      await _notasProvider.eliminarNota(id);

      // Actualizar lista local
      await cargarNotas();

      return true;
    } catch (e) {
      error.value = 'Error al eliminar nota: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
}
