import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/estadisticas_controller.dart';
import '../../../data/models/material_model.dart';
import '../../../routes/app_routes.dart';

class AlertasInventarioComponent extends GetView<EstadisticasController> {
  const AlertasInventarioComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey5),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alertas de Inventario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          const Text(
            'Materiales con stock bajo',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 12,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de materiales con stock bajo
          Obx(() {
            if (controller.materialesBajoStock.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No hay alertas de inventario',
                    style: TextStyle(
                      color: CupertinoColors.systemGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.materialesBajoStock.length,
              separatorBuilder: (context, index) => Container (height: 1),
              itemBuilder: (context, index) {
                final material = controller.materialesBajoStock[index];
                return _buildMaterialItem(material);
              },
            );
          }),
          
          const SizedBox(height: 16),
          
          // Botón para ir a inventario
          if (controller.materialesBajoStock.isNotEmpty) ...[
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.arrow_right_circle),
                  SizedBox(width: 8),
                  Text('Ir a Inventario'),
                ],
              ),
              onPressed: () => Get.toNamed(AppRoutes.INVENTARIO),
            ),
          ],
        ],
      ),
    );
  }
  
  // Construir item de material
  Widget _buildMaterialItem(MaterialModel material) {
    // Determinar el nivel de severidad según la relación entre disponible y mínimo
    Color getSeverityColor(int disponible, int minimo) {
      final ratio = disponible / minimo;
      
      if (disponible == 0) {
        return CupertinoColors.systemRed;
      } else if (ratio <= 0.5) {
        return CupertinoColors.systemOrange;
      } else {
        return CupertinoColors.systemYellow;
      }
    }
    
    // Icono según tipo de material
    IconData getIconByTipo(TipoMaterial tipo) {
      switch (tipo) {
        case TipoMaterial.hoja:
          return CupertinoIcons.doc;
        case TipoMaterial.laminado:
          return CupertinoIcons.layers;
        case TipoMaterial.tinta:
          return CupertinoIcons.paintbrush;
        case TipoMaterial.otros:
        default:
          return CupertinoIcons.cube;
      }
    }
    
    final color = getSeverityColor(material.cantidadDisponible, material.cantidadMinima);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Icono según tipo de material
          Icon(
            getIconByTipo(material.tipo),
            color: color,
            size: 24,
          ),
          
          const SizedBox(width: 16),
          
          // Información del material
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  material.descripcion,
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Indicador de stock
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Cantidad disponible
              Text(
                'Disponible: ${material.cantidadDisponible}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              
              // Cantidad mínima
              Text(
                'Mínimo: ${material.cantidadMinima}',
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 8),
          
          // Indicador de prioridad
          if (material.cantidadDisponible == 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'URGENTE',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}