// lib/app/controllers/notas_controller.dart
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../data/models/nota_model.dart';
import '../data/services/notas_service.dart';

class NotasController extends GetxController {
  // Servicio
  final NotasService _notasService = Get.find<NotasService>();

  // Variables reactivas
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  final RxString filtroCategoria = 'Todas'.obs;

  // Nota seleccionada para edición
  final Rx<NotaModel?> notaSeleccionada = Rx<NotaModel?>(null);

  // Getters para las variables del servicio
  RxList<NotaModel> get notas => _notasService.notas;

  @override
  void onInit() async {
    super.onInit();
    await cargarNotas();
  }

  // Cargar notas
  Future<void> cargarNotas() async {
    try {
      cargando.value = true;
      error.value = '';

      await _notasService.cargarNotas();
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
      return id.isNotEmpty;
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
      return await _notasService.actualizarNota(nota);
    } catch (e) {
      error.value = 'Error al actualizar nota: $e';
      print(error.value);
      return false;
    }
  }

  // Eliminar nota
  Future<bool> eliminarNota(String id) async {
    try {
      return await _notasService.eliminarNota(id);
    } catch (e) {
      error.value = 'Error al eliminar nota: $e';
      print(error.value);
      return false;
    }
  }

  // Filtrar por categoría
  void cambiarFiltroCategoria(String categoria) {
    filtroCategoria.value = categoria;
  }

  // Getter para notas filtradas
  List<NotaModel> get notasFiltradas {
    if (filtroCategoria.value == 'Todas') {
      return notas;
    }

    return notas
        .where((nota) => nota.categoria == filtroCategoria.value)
        .toList();
  }
}
