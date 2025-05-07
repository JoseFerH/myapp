import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/venta_model.dart';
import '../models/cliente_model.dart';
import '../models/material_model.dart';
import '../providers/ventas_provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/materiales_provider.dart';
import '../models/item_venta_model.dart';

class ExportacionService extends GetxService {
  final VentasProvider _ventasProvider = VentasProvider();
  final ClientesProvider _clientesProvider = ClientesProvider();
  final MaterialesProvider _materialesProvider = MaterialesProvider();
  
  // Rx Variables para el estado
  final RxBool exportando = false.obs;
  final RxString error = ''.obs;
  
  // Formato de fecha
  final formatoFecha = DateFormat('dd/MM/yyyy');
  
  // Formato de moneda
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );
  
  // Exportar ventas a CSV
  Future<File?> exportarVentasCSV(DateTime fechaInicio, DateTime fechaFin) async {
    try {
      exportando.value = true;
      error.value = '';
      
      // Obtener las ventas del período
      List<VentaModel> ventas = await _ventasProvider.obtenerVentasPorFecha(fechaInicio, fechaFin);
      
      // Crear contenido CSV
      String csvContent = 'ID,Fecha,Cliente,Estado,Subtotal,Envío,Total\n';
      
      for (var venta in ventas) {
        String estado = '';
        switch (venta.estado) {
          case EstadoVenta.cotizacion:
            estado = 'Cotización';
            break;
          case EstadoVenta.pendiente:
            estado = 'Pendiente';
            break;
          case EstadoVenta.completada:
            estado = 'Completada';
            break;
          case EstadoVenta.cancelada:
            estado = 'Cancelada';
            break;
        }
        
        csvContent += '${venta.id},${formatoFecha.format(venta.fecha)},"${venta.nombreCliente}",'
                    + '$estado,${venta.subtotal},${venta.costoEnvio},${venta.total}\n';
      }
      
      // Guardar archivo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/ventas_${formatoFecha.format(fechaInicio)}_${formatoFecha.format(fechaFin)}.csv';
      final file = File(path);
      await file.writeAsString(csvContent);
      
      return file;
    } catch (e) {
      error.value = 'Error al exportar ventas: $e';
      print(error.value);
      return null;
    } finally {
      exportando.value = false;
    }
  }
  
  // Exportar clientes a CSV
  Future<File?> exportarClientesCSV() async {
    try {
      exportando.value = true;
      error.value = '';
      
      // Obtener todos los clientes
      List<ClienteModel> clientes = await _clientesProvider.obtenerClientes();
      
      // Crear contenido CSV
      String csvContent = 'ID,Nombre,Dirección,Tipo,Zona,Total Gastado\n';
      
      for (var cliente in clientes) {
        csvContent += '${cliente.id},"${cliente.nombre}","${cliente.direccion}",'
                    + '${cliente.tipoCliente},${cliente.zona},${cliente.totalGastado}\n';
      }
      
      // Guardar archivo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/clientes_${formatoFecha.format(DateTime.now())}.csv';
      final file = File(path);
      await file.writeAsString(csvContent);
      
      return file;
    } catch (e) {
      error.value = 'Error al exportar clientes: $e';
      print(error.value);
      return null;
    } finally {
      exportando.value = false;
    }
  }
  
  // Exportar inventario a CSV
  Future<File?> exportarInventarioCSV() async {
    try {
      exportando.value = true;
      error.value = '';
      
      // Obtener todos los materiales
      List<MaterialModel> materiales = await _materialesProvider.obtenerMateriales();
      
      // Crear contenido CSV
      String csvContent = 'ID,Nombre,Tipo,Precio,Stock,Stock Mínimo,Fecha Compra\n';
      
      for (var material in materiales) {
        String tipo = material.tipo.toString().split('.').last;
        
        csvContent += '${material.id},"${material.nombre}",${tipo},'
                    + '${material.precioUnitario},${material.cantidadDisponible},${material.cantidadMinima},'
                    + '${formatoFecha.format(material.fechaCompra)}\n';
      }
      
      // Guardar archivo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/inventario_${formatoFecha.format(DateTime.now())}.csv';
      final file = File(path);
      await file.writeAsString(csvContent);
      
      return file;
    } catch (e) {
      error.value = 'Error al exportar inventario: $e';
      print(error.value);
      return null;
    } finally {
      exportando.value = false;
    }
  }
  
  // Compartir archivo CSV
  Future<void> compartirCSV(File file, String titulo) async {
    try {
      await Share.shareXFiles([XFile(file.path)], text: titulo);
    } catch (e) {
      error.value = 'Error al compartir archivo: $e';
      print(error.value);
    }
  }
  
  // Exportar detalle de venta a CSV
  Future<File?> exportarDetalleVentaCSV(String ventaId) async {
    try {
      exportando.value = true;
      error.value = '';
      
      // Obtener la venta
      VentaModel venta = await _ventasProvider.obtenerVentaPorId(ventaId);
      
      // Crear contenido CSV
      String csvContent = 'Cotización: ${venta.id}\n';
      csvContent += 'Cliente: ${venta.nombreCliente}\n';
      csvContent += 'Fecha: ${formatoFecha.format(venta.fecha)}\n\n';
      
      csvContent += 'Cant.,Descripción,Tamaño,Precio Unit.,Total\n';
      
      for (var item in venta.items) {
        String tamano = '';
        switch (item.tamano) {
          case TamanoSticker.cuarto:
            tamano = '1/4';
            break;
          case TamanoSticker.medio:
            tamano = '1/2';
            break;
          case TamanoSticker.tresQuartos:
            tamano = '3/4';
            break;
          case TamanoSticker.completo:
            tamano = 'Completo';
            break;
        }
        
        String descripcion = 'Sticker ${item.nombreHoja} con laminado ${item.nombreLaminado}';
        
        csvContent += '${item.cantidad},"$descripcion",$tamano,${item.precioUnitario},${item.precioTotal}\n';
      }
      
      csvContent += '\nSubtotal,${venta.subtotal}\n';
      csvContent += 'Envío,${venta.costoEnvio}\n';
      csvContent += 'Total,${venta.total}\n';
      
      if (venta.notas.isNotEmpty) {
        csvContent += '\nNotas: ${venta.notas}\n';
      }
      
      // Guardar archivo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/venta_${venta.id}.csv';
      final file = File(path);
      await file.writeAsString(csvContent);
      
      return file;
    } catch (e) {
      error.value = 'Error al exportar detalle: $e';
      print(error.value);
      return null;
    } finally {
      exportando.value = false;
    }
  }
}