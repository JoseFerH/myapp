import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/carrito_controller.dart';

class BotonCotizacionComponent extends GetView<CarritoController> {
  const BotonCotizacionComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => CupertinoButton(
      padding: const EdgeInsets.all(12),
      color: CupertinoColors.activeBlue,
      disabledColor: CupertinoColors.systemGrey4,
      onPressed: controller.clienteSeleccionado.value == null
          ? null
          : () => _generarCotizacion(context),
      child: controller.cargando.value
          ? const CupertinoActivityIndicator(color: CupertinoColors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(CupertinoIcons.doc_text),
                SizedBox(width: 8),
                Text('Generar Cotización'),
              ],
            ),
    ));
  }
  
  // Generar cotización
  void _generarCotizacion(BuildContext context) async {
    // Verificar si hay cliente seleccionado
    if (controller.clienteSeleccionado.value == null) {
      _mostrarError(context, 'Por favor seleccione un cliente');
      return;
    }
    
    // Verificar si hay items en el carrito
    if (controller.items.isEmpty) {
      _mostrarError(context, 'El carrito está vacío');
      return;
    }
    
    // Generar cotización
    try {
      await controller.generarCotizacion();
      
      // Mostrar mensaje de éxito
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Cotización Generada'),
          content: const Text('La cotización ha sido generada y compartida exitosamente.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } catch (e) {
      _mostrarError(context, 'Error al generar cotización: $e');
    }
  }
  
  // Mostrar error
  void _mostrarError(BuildContext context, String mensaje) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(mensaje),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}