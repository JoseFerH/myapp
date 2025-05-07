import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../models/venta_model.dart';
import '../models/item_venta_model.dart';

class PDFService extends GetxService {
  // Rx Variables para el estado
  final RxBool generando = false.obs;
  final RxString error = ''.obs;
  
  // Formato de moneda para Guatemala (Quetzales)
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );
  
  // Generar cotización en PDF
  Future<File?> generarCotizacion(VentaModel venta) async {
    try {
      generando.value = true;
      error.value = '';
      
      // Crear documento PDF
      final pdf = pw.Document();
      
      // Agregar página con contenido
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.letter,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) => _construirContenidoCotizacion(venta),
        ),
      );
      
      // Guardar PDF
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/cotizacion_${venta.id}.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
      
      return file;
    } catch (e) {
      error.value = 'Error al generar PDF: $e';
      print(error.value);
      return null;
    } finally {
      generando.value = false;
    }
  }
  
  // Construir contenido de la cotización
  List<pw.Widget> _construirContenidoCotizacion(VentaModel venta) {
    final fecha = DateFormat('dd/MM/yyyy').format(venta.fecha);
    
    return [
      // Encabezado
      pw.Header(
        level: 0,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('COTIZACIÓN', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.Text('Fecha: $fecha', style: pw.TextStyle(fontSize: 14)),
          ],
        ),
      ),
      
      pw.SizedBox(height: 20),
      
      // Información de la empresa
      pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Creati Stickers', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text('Stickers personalizados de alta calidad'),
            pw.Text('Tel: 1234-5678'),
            pw.Text('Ciudad de Guatemala'),
          ],
        ),
      ),
      
      pw.SizedBox(height: 30),
      
      // Información del cliente
      pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Cliente:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(venta.nombreCliente),
            pw.SizedBox(height: 5),
            pw.Text('No. Cotización: ${venta.id}'),
          ],
        ),
      ),
      
      pw.SizedBox(height: 20),
      
      // Tabla de items
      pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          1: const pw.FlexColumnWidth(4),
          2: const pw.FlexColumnWidth(1),
          3: const pw.FlexColumnWidth(1.5),
          4: const pw.FlexColumnWidth(1.5),
        },
        children: [
          // Encabezado de tabla
          pw.TableRow(
            decoration: pw.BoxDecoration(color: PdfColors.grey300),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Cant.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Descripción', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Tamaño', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Precio Unit.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
            ],
          ),
          
          // Filas de productos
          ...venta.items.map((item) => _construirFilaItem(item)),
        ],
      ),
      
      pw.SizedBox(height: 20),
      
      // Tabla de totales
      pw.Container(
        alignment: pw.Alignment.centerRight,
        child: pw.Table(
          columnWidths: {
            0: const pw.FixedColumnWidth(100),
            1: const pw.FixedColumnWidth(100),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Text('Subtotal:', textAlign: pw.TextAlign.right),
                pw.Text(formatoMoneda.format(venta.subtotal), textAlign: pw.TextAlign.right),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Text('Envío:', textAlign: pw.TextAlign.right),
                pw.Text(formatoMoneda.format(venta.costoEnvio), textAlign: pw.TextAlign.right),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 5),
                  child: pw.Text('TOTAL:', 
                    textAlign: pw.TextAlign.right, 
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 5),
                  child: pw.Text(formatoMoneda.format(venta.total), 
                    textAlign: pw.TextAlign.right, 
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
      
      pw.SizedBox(height: 30),
      
      // Notas
      pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Notas:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text(venta.notas.isNotEmpty ? venta.notas : 'Sin notas adicionales'),
            pw.SizedBox(height: 10),
            pw.Text('Envío: ${_obtenerDescripcionEnvio(venta)}'),
            pw.SizedBox(height: 5),
            pw.Text('Esta cotización tiene validez por 7 días.'),
          ],
        ),
      ),
      
      pw.SizedBox(height: 40),
      
      // Pie de página
      pw.Footer(
        leading: pw.Text('¡Gracias por su preferencia!'),
        title: pw.Text('@Creati.Stickers', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
      ),
    ];
  }
  
  // Construir fila de item
  pw.TableRow _construirFilaItem(ItemVentaModel item) {
    String tamanoTexto = '';
    switch (item.tamano) {
      case TamanoSticker.cuarto:
        tamanoTexto = '1/4';
        break;
      case TamanoSticker.medio:
        tamanoTexto = '1/2';
        break;
      case TamanoSticker.tresQuartos:
        tamanoTexto = '3/4';
        break;
      case TamanoSticker.completo:
        tamanoTexto = 'Completo';
        break;
    }
    
    String descripcion = 'Sticker ${item.nombreHoja} con laminado ${item.nombreLaminado}';
    if (item.tipoDiseno == TipoDiseno.personalizado) {
      descripcion += ' (Diseño personalizado)';
    }
    
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text('${item.cantidad}', textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(descripcion),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(tamanoTexto, textAlign: pw.TextAlign.center),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(formatoMoneda.format(item.precioUnitario), textAlign: pw.TextAlign.right),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(formatoMoneda.format(item.precioTotal), textAlign: pw.TextAlign.right),
        ),
      ],
    );
  }
  
  // Obtener descripción de tipo de envío
  String _obtenerDescripcionEnvio(VentaModel venta) {
    switch (venta.tipoEnvio) {
      case TipoEnvio.normal:
        return 'Normal - Entrega en 2-3 días hábiles';
      case TipoEnvio.express:
        return 'Express - Entrega en 24 horas';
      case TipoEnvio.personalizado:
        return 'Personalizado - A coordinar';
      default:
        return 'A coordinar';
    }
  }
  
  // Compartir PDF generado
  Future<void> compartirPDF(File file) async {
    try {
      await Share.shareXFiles([XFile(file.path)], text: 'Cotización de Stickers');
    } catch (e) {
      error.value = 'Error al compartir PDF: $e';
      print(error.value);
    }
  }
}