// lib/app/controllers/visualizacion_controller.dart

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/venta_model.dart';
import '../data/services/venta_service.dart';
import '../data/services/exportacion_service.dart';
import '../data/services/pdf_service.dart';

class VisualizacionController extends GetxController {
  // Servicios
  final VentaService _ventaService = Get.find<VentaService>();
  final ExportacionService _exportacionService = Get.find<ExportacionService>();
  final PDFService _pdfService = Get.find<PDFService>();
  
  // Variables reactivas de UI
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  
  // Variables para filtros
  final Rx<DateTime> fechaInicio = DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> fechaFin = DateTime.now().obs;
  final RxString clienteId = ''.obs;
  final Rx<EstadoVenta?> estadoSeleccionado = Rx<EstadoVenta?>(null);
  
  // Datos visualizados
  final RxList<VentaModel> ventas = <VentaModel>[].obs;
  final Rx<VentaModel?> ventaSeleccionada = Rx<VentaModel?>(null);
  
  // Formateo de datos
  final formatoFecha = DateFormat('dd/MM/yyyy');
  final formatoMoneda = NumberFormat.currency(locale: 'es_GT', symbol: 'Q');
  
  // Controladores para TextFields
  late TextEditingController busquedaController;
  
  @override
  void onInit() async {
    super.onInit();
    busquedaController = TextEditingController();
    await cargarVentas();
  }
  
  @override
  void onClose() {
    busquedaController.dispose();
    super.onClose();
  }
  
  // Cargar ventas según filtros
  Future<void> cargarVentas() async {
    try {
      cargando.value = true;
      error.value = '';
      
      List<VentaModel> lista;
      
      // Filtrar por cliente si hay uno seleccionado
      if (clienteId.isNotEmpty) {
        lista = await _ventaService.cargarVentasPorCliente(clienteId.value);
      } else {
        // Filtrar por fechas
        lista = await _ventaService.cargarVentasPorFecha(fechaInicio.value, fechaFin.value);
      }
      
      // Filtrar por estado si hay uno seleccionado
      if (estadoSeleccionado.value != null) {
        lista = lista.where((v) => v.estado == estadoSeleccionado.value).toList();
      }
      
      ventas.assignAll(lista);
    } catch (e) {
      error.value = 'Error al cargar ventas: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Seleccionar venta para detalles
  void seleccionarVenta(VentaModel venta) {
    ventaSeleccionada.value = venta;
  }
  
  // Cambiar filtros de fecha
  void cambiarFechaInicio(DateTime fecha) {
    fechaInicio.value = fecha;
    cargarVentas();
  }
  
  void cambiarFechaFin(DateTime fecha) {
    fechaFin.value = fecha;
    cargarVentas();
  }
  
  // Filtrar por estado
  void filtrarPorEstado(EstadoVenta? estado) {
    estadoSeleccionado.value = estado;
    cargarVentas();
  }
  
  // Filtrar por cliente
  void filtrarPorCliente(String id) {
    clienteId.value = id;
    cargarVentas();
  }
  
  // Limpiar filtros
  void limpiarFiltros() {
    fechaInicio.value = DateTime.now().subtract(const Duration(days: 30));
    fechaFin.value = DateTime.now();
    clienteId.value = '';
    estadoSeleccionado.value = null;
    busquedaController.clear();
    cargarVentas();
  }
  
  // Exportar a CSV
  Future<void> exportarVentasCSV() async {
    try {
      cargando.value = true;
      error.value = '';
      
      File? archivoCSV = await _exportacionService.exportarVentasCSV(
        fechaInicio.value,
        fechaFin.value
      );
      
      if (archivoCSV != null) {
        // Compartir archivo
        await _exportacionService.compartirCSV(
          archivoCSV,
          'Ventas ${formatoFecha.format(fechaInicio.value)} - ${formatoFecha.format(fechaFin.value)}'
        );
        
        Get.snackbar(
          'Éxito',
          'Datos exportados correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        error.value = 'Error al exportar datos';
      }
    } catch (e) {
      error.value = 'Error al exportar: $e';
      print(error.value);
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      cargando.value = false;
    }
  }
  
  // Generar PDF de venta seleccionada
  Future<void> generarPDFVenta() async {
    try {
      cargando.value = true;
      error.value = '';
      
      if (ventaSeleccionada.value == null) {
        error.value = 'No hay venta seleccionada';
        return;
      }
      
      File? pdfFile = await _pdfService.generarCotizacion(ventaSeleccionada.value!);
      
      if (pdfFile != null) {
        // Compartir PDF
        await _pdfService.compartirPDF(pdfFile);
        
        Get.snackbar(
          'Éxito',
          'PDF generado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        error.value = 'Error al generar PDF';
      }
    } catch (e) {
      error.value = 'Error al generar PDF: $e';
      print(error.value);
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      cargando.value = false;
    }
  }
  
  // Cambiar estado de venta
  Future<void> cambiarEstadoVenta(EstadoVenta nuevoEstado) async {
    try {
      cargando.value = true;
      error.value = '';
      
      if (ventaSeleccionada.value == null) {
        error.value = 'No hay venta seleccionada';
        return;
      }
      
      bool resultado = await _ventaService.cambiarEstadoVenta(
        ventaSeleccionada.value!.id,
        nuevoEstado
      );
      
      if (resultado) {
        // Recargar venta seleccionada
        await _ventaService.cargarVentaPorId(ventaSeleccionada.value!.id);
        await cargarVentas();
        
        Get.snackbar(
          'Éxito',
          'Estado cambiado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        error.value = 'Error al cambiar estado';
      }
    } catch (e) {
      error.value = 'Error al cambiar estado: $e';
      print(error.value);
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      cargando.value = false;
    }
  }
}