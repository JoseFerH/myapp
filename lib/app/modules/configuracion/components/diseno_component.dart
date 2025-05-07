import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/configuracion_controller.dart';

class DisenoComponent extends GetView<ConfiguracionController> {
  const DisenoComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        const Text(
          'Configuración de Diseño',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          'Define los precios para los diferentes tipos de diseño.',
          style: TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 14,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Precio de diseño estándar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CupertinoColors.systemGrey5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Precio de Diseño Estándar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Precio base para diseños estándar (no personalizados).',
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Precio:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: CupertinoTextField(
                      padding: const EdgeInsets.all(12),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Q'),
                      ),
                      placeholder: '0.00',
                      controller: TextEditingController(
                        text: controller.precioDisenioEstandar.toString(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            controller.precioDisenioEstandar.value = double.parse(value);
                          } catch (e) {
                            // Ignorar si no es un valor numérico válido
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Nota: El precio de 0 significa que no se cobra adicional por el diseño estándar.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Precio de diseño personalizado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CupertinoColors.systemGrey5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Precio Base de Diseño Personalizado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Precio predeterminado para diseños personalizados.',
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Precio:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: CupertinoTextField(
                      padding: const EdgeInsets.all(12),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Q'),
                      ),
                      placeholder: '0.00',
                      controller: TextEditingController(
                        text: controller.precioDisenioPersonalizado.toString(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            controller.precioDisenioPersonalizado.value = double.parse(value);
                          } catch (e) {
                            // Ignorar si no es un valor numérico válido
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Nota: Este valor se mostrará por defecto al seleccionar diseño personalizado, pero puede modificarse en cada cotización.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Precios especiales por tipo de sticker
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CupertinoColors.systemGrey5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Precios Especiales por Tamaño',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Precios especiales que se aplicarán automáticamente según el tamaño del sticker.',
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              
              // Precio para 1/4 de hoja
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      '1/4 de hoja:',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  
                  Expanded(
                    child: CupertinoTextField(
                      padding: const EdgeInsets.all(12),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Q'),
                      ),
                      placeholder: '0.00',
                      controller: TextEditingController(
                        text: controller.precioCuartoHoja.toString(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            controller.precioCuartoHoja.value = double.parse(value);
                          } catch (e) {
                            // Ignorar si no es un valor numérico válido
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Precio para 1/2 hoja en adelante
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      '1/2 hoja+:',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  
                  Expanded(
                    child: CupertinoTextField(
                      padding: const EdgeInsets.all(12),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Q'),
                      ),
                      placeholder: '0.00',
                      controller: TextEditingController(
                        text: controller.precioMediaHoja.toString(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            controller.precioMediaHoja.value = double.parse(value);
                          } catch (e) {
                            // Ignorar si no es un valor numérico válido
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}