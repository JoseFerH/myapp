import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/configuracion_controller.dart';

class EnvioComponent extends GetView<ConfiguracionController> {
  const EnvioComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        const Text(
          'Configuración de Envíos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          'Define los costos de envío para diferentes modalidades.',
          style: TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 14,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Costo de envío normal (Q18)
        _buildCostoEnvioSection(
          'Costo de Envío Normal',
          'Costo estándar para entregas en 2-3 días hábiles.',
          controller.costoEnvioNormal,
          (value) => controller.costoEnvioNormal.value = value,
        ),
        
        const SizedBox(height: 24),
        
        // Costo de envío express (Q30)
        _buildCostoEnvioSection(
          'Costo de Envío Express',
          'Costo para entregas en 24 horas.',
          controller.costoEnvioExpress,
          (value) => controller.costoEnvioExpress.value = value,
        ),
        
        const SizedBox(height: 24),
        
        // Paquete de redes sociales (3 por Q90)
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
                'Paquete Redes Sociales',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Precio para el paquete especial de 3 stickers con envío incluido.',
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
                    '3 stickers por:',
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
                        text: controller.precioRedesSociales.toString(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            controller.precioRedesSociales.value = double.parse(value);
                          } catch (e) {
                            // Ignorar si no es un valor numérico válido
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              const Text(
                'Incluye envío',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Precio mayorista (a partir de 100 unidades, Q10 c/u)
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
                'Precio Mayorista',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Precio especial para pedidos a partir de cierta cantidad.',
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              
              // Cantidad mínima
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'A partir de:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: CupertinoTextField(
                      padding: const EdgeInsets.all(12),
                      keyboardType: TextInputType.number,
                      placeholder: '100',
                      controller: TextEditingController(
                        text: controller.cantidadMayorista.toString(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            controller.cantidadMayorista.value = int.parse(value);
                          } catch (e) {
                            // Ignorar si no es un valor numérico válido
                          }
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  const Text('unidades'),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Precio mayorista
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Precio c/u:',
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
                        text: controller.precioMayorista.toString(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            controller.precioMayorista.value = double.parse(value);
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
  
  // Construir sección de costo de envío
  Widget _buildCostoEnvioSection(
    String title,
    String description,
    RxDouble value,
    Function(double) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Costo:',
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
                    text: value.toString(),
                  ),
                  onChanged: (textValue) {
                    if (textValue.isNotEmpty) {
                      try {
                        onChanged(double.parse(textValue));
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
    );
  }
}