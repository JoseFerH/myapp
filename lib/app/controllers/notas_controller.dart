// lib/app/controllers/notas_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/models/nota_model.dart';
import '../data/services/notas_service.dart';

class NotasController extends GetxController {
  // Servicio - usar late para inicializar en onInit
  late NotasService _notasService;

  // Variables reactivas
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  final RxString filtroCategoria = 'Todas'.obs;

  // Nota seleccionada para edición
  final Rx<NotaModel?> notaSeleccionada = Rx<NotaModel?>(null);

  // Lista local de notas
  final RxList<NotaModel> _localNotas = <NotaModel>[].obs;

  // Getters para las notas
  RxList<NotaModel> get notas => _localNotas;

  @override
  void onInit() {
    super.onInit();
    _initNotasService();
  }

  // Inicializar el servicio de notas
  void _initNotasService() {
    try {
      // Verificar si el servicio ya está registrado
      if (Get.isRegistered<NotasService>()) {
        _notasService = Get.find<NotasService>();
      } else {
        // Si no está registrado, crearlo
        _notasService = Get.put(NotasService(), permanent: true);
      }

      // Cargar las notas (sin await, para no bloquear la UI)
      cargarNotas();
    } catch (e) {
      error.value = 'Error al inicializar notas: $e';
      print(error.value);
    }
  }

  // Cargar notas
  Future<void> cargarNotas() async {
    try {
      cargando.value = true;
      error.value = '';

      await _notasService.cargarNotas();
      // Actualizar lista local
      _localNotas.assignAll(_notasService.notas);
    } catch (e) {
      error.value = 'Error al cargar notas: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Crear nota
  Future<bool> crearNota(NotaModel nota) async {
    try {
      cargando.value = true;
      error.value = '';

      String id = await _notasService.crearNota(nota);
      if (id.isNotEmpty) {
        await cargarNotas();
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Error al crear nota: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  // Actualizar nota
  Future<bool> actualizarNota(NotaModel nota) async {
    try {
      cargando.value = true;
      error.value = '';

      bool result = await _notasService.actualizarNota(nota);
      if (result) {
        await cargarNotas();
      }
      return result;
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

      bool result = await _notasService.eliminarNota(id);
      if (result) {
        await cargarNotas();
      }
      return result;
    } catch (e) {
      error.value = 'Error al eliminar nota: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  // Filtrar por categoría
  void cambiarFiltroCategoria(String categoria) {
    filtroCategoria.value = categoria;
  }

  // Getter para notas filtradas
  List<NotaModel> get notasFiltradas {
    if (filtroCategoria.value == 'Todas') {
      return _localNotas;
    }

    return _localNotas
        .where((nota) => nota.categoria == filtroCategoria.value)
        .toList();
  }
}
