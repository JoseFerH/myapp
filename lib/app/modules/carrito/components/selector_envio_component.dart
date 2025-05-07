import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/carrito_controller.dart';
import '../../../data/models/venta_model.dart';

class SelectorEnvioComponent extends GetView<CarritoController> {
  SelectorEnvioComponent({Key? key}) : super(key: key);

  // Formato para moneda guatemalteca
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tipo de Envío',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Opciones de envío
          Obx(() => CupertinoSegmentedControl<TipoEnvio>(
            children: {
              TipoEnvio.normal: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text("Normal\n${formatoMoneda.format(controller.costoEnvioNormal.value)}"),
              ),
              TipoEnvio.express: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text("Express\n${formatoMoneda.format(controller.costoEnvioExpress.value)}"),
              ),
              TipoEnvio.personalizado: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Personalizado"),
              ),
            },
            groupValue: controller.tipoEnvio.value,
            onValueChanged: (value) {
              controller.seleccionarTipoEnvio(value);
              
              // Si es personalizado, mostrar diálogo para ingresar precio
              if (value == TipoEnvio.personalizado) {
                _mostrarDialogoPrecioEnvio(context);
              }
            },
          )),
          
          const SizedBox(height: 16),
          
          // Mostrar información del envío seleccionado
          Obx(() {
            String descripcion;
            switch (controller.tipoEnvio.value) {
              case TipoEnvio.normal:
                descripcion = 'Entrega en 2-3 días hábiles';
                break;
              case TipoEnvio.express:
                descripcion = 'Entrega en 24 horas';
                break;
              case TipoEnvio.personalizado:
                descripcion = 'Envío personalizado: ${formatoMoneda.format(controller.costoEnvioPersonalizado.value)}';
                break;
              default:
                descripcion = '';
            }
            
            return Text(
              descripcion,
              style: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
              ),
            );
          }),
        ],
      ),
    );
  }
  
  // Diálogo para ingresar precio de envío personalizado
  void _mostrarDialogoPrecioEnvio(BuildContext context) {
    final TextEditingController precioController = TextEditingController(
      text: controller.costoEnvioPersonalizado.value.toString(),
    );
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Precio de Envío Personalizado'),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CupertinoTextField(
            controller: precioController,
            placeholder: 'Ingrese precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefix: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Q'),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () {
              // Volver a tipo normal si cancela
              controller.seleccionarTipoEnvio(TipoEnvio.normal);
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Aceptar'),
            onPressed: () {
              // Validar y guardar precio
              if (precioController.text.isNotEmpty) {
                try {
                  double precio = double.parse(precioController.text);
                  controller.setCostoEnvioPersonalizado(precio);
                  controller.seleccionarTipoEnvio(TipoEnvio.personalizado);
                } catch (e) {
                  // Si hay error, establecer valor por defecto
                  controller.setCostoEnvioPersonalizado(0.0);
                }
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}