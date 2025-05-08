// lib/app/modules/visualizacion/components/exportar_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/visualizacion_controller.dart';

class ExportarComponent extends GetView<VisualizacionController> {
  ExportarComponent({Key? key}) : super(key: key);

  // Formato para fechas
  final formatoFecha = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(12),
      color: CupertinoColors.systemIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(CupertinoIcons.share),
          SizedBox(width: 8),
          Text('Exportar Datos'),
        ],
      ),
      onPressed: () => _mostrarOpcionesExportacion(context),
    );
  }
  
  // Mostrar opciones de exportación
  void _mostrarOpcionesExportacion(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exportar Datos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Obx(() => Text(
              'Período: ${formatoFecha.format(controller.fechaInicio.value)} - ${formatoFecha.format(controller.fechaFin.value)}',
              style: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
              ),
            )),
            
            const SizedBox(height: 16),
            
            // Opciones de exportación
            Expanded(
              child: ListView(
                children: [
                  _buildOpcionExportacion(
                    context,
                    'Exportar a CSV',
                    'Archivo separado por comas para hojas de cálculo',
                    CupertinoIcons.doc_text,
                    CupertinoColors.systemGreen,
                    controller.exportarVentasCSV,
                  ),
                  _buildOpcionExportacion(
                    context,
                    'Exportar a PDF',
                    'Reporte detallado en formato PDF',
                    CupertinoIcons.doc_chart,
                    CupertinoColors.systemRed,
                    () {
                      // Verificar si hay venta seleccionada
                      if (controller.ventaSeleccionada.value != null) {
                        controller.generarPDFVenta();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Seleccione una venta para generar PDF',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                      Navigator.pop(context);
                    },
                  ),
                  _buildOpcionExportacion(
                    context,
                    'Enviar por Correo',
                    'Enviar los datos por correo electrónico',
                    CupertinoIcons.mail,
                    CupertinoColors.systemBlue,
                    () {
                      // Implementar funcionalidad para enviar por correo
                      Navigator.pop(context);
                      Get.snackbar(
                        'Información',
                        'Funcionalidad de correo en desarrollo',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  _buildOpcionExportacion(
                    context,
                    'Compartir por WhatsApp',
                    'Enviar a WhatsApp como documento',
                    CupertinoIcons.chat_bubble_text,
                    CupertinoColors.systemGreen,
                    () {
                      // Implementar funcionalidad para compartir por WhatsApp
                      Navigator.pop(context);
                      Get.snackbar(
                        'Información',
                        'Funcionalidad de WhatsApp en desarrollo',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Botón para cerrar
            Center(
              child: CupertinoButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Construir opción de exportación
  Widget _buildOpcionExportacion(
    BuildContext context,
    String titulo,
    String subtitulo,
    IconData icono,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey5,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icono,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }
}