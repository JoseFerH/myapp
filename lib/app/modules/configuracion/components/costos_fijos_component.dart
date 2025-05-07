import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/configuracion_controller.dart';
import '../../../data/models/costo_fijo_model.dart';

class CostosFijosComponent extends GetView<ConfiguracionController> {
  const CostosFijosComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        const Text(
          'Costos Fijos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          'Estos costos se aplicarán a todos los cálculos de precios.',
          style: TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 14,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Lista de costos fijos
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.costosFijos.length,
          itemBuilder: (context, index) {
            final costo = controller.costosFijos[index];
            return _buildCostoItem(context, costo);
          },
        )),
        
        const SizedBox(height: 20),
        
        // Botón para agregar nuevo costo fijo
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(CupertinoIcons.add_circled),
              SizedBox(width: 8),
              Text('Agregar Costo Fijo'),
            ],
          ),
          onPressed: () => _mostrarFormularioCosto(context),
        ),
      ],
    );
  }
  
  // Construir item de costo fijo
  Widget _buildCostoItem(BuildContext context, CostoFijoModel costo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Switch para activar/desactivar
            CupertinoSwitch(
              value: costo.activo,
              onChanged: (value) {
                controller.toggleCostoFijo(costo.id, value);
              },
            ),
            
            const SizedBox(width: 12),
            
            // Información del costo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    costo.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (costo.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      costo.descripcion,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Valor del costo
            Text(
              'Q${costo.valor.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Botones de editar y eliminar
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.pencil,
                size: 20,
              ),
              onPressed: () => _mostrarFormularioCosto(context, costo),
            ),
            
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.delete,
                size: 20,
                color: CupertinoColors.systemRed,
              ),
              onPressed: () => _confirmarEliminarCosto(context, costo),
            ),
          ],
        ),
      ),
    );
  }
  
  // Mostrar formulario para agregar o editar costo fijo
  void _mostrarFormularioCosto(BuildContext context, [CostoFijoModel? costo]) {
    // Controladores para los campos
    final nombreController = TextEditingController(text: costo?.nombre ?? '');
    final descripcionController = TextEditingController(text: costo?.descripcion ?? '');
    final valorController = TextEditingController(
      text: costo?.valor.toString() ?? '0.0',
    );
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
            // Título del modal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  costo == null ? 'Nuevo Costo Fijo' : 'Editar Costo Fijo',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Formulario
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nombre:'),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: nombreController,
                      placeholder: 'Nombre del costo fijo',
                      padding: const EdgeInsets.all(12),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text('Descripción (opcional):'),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: descripcionController,
                      placeholder: 'Breve descripción',
                      padding: const EdgeInsets.all(12),
                      maxLines: 2,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text('Valor (Q):'),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: valorController,
                      placeholder: '0.00',
                      padding: const EdgeInsets.all(12),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Q'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                child: Text(costo == null ? 'Crear Costo Fijo' : 'Actualizar Costo Fijo'),
                onPressed: () {
                  // Validar campos
                  if (nombreController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'El nombre es obligatorio',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  
                  // Validar valor
                  double valor;
                  try {
                    valor = double.parse(valorController.text);
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Valor inválido',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  
                  // Crear o actualizar costo fijo
                  final costoFijo = CostoFijoModel(
                    id: costo?.id ?? '',
                    nombre: nombreController.text,
                    descripcion: descripcionController.text,
                    valor: valor,
                    activo: costo?.activo ?? true,
                  );
                  
                  // Guardar cambios
                  controller.guardarCostoFijo(costoFijo).then((_) {
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Confirmar eliminación de costo fijo
  void _confirmarEliminarCosto(BuildContext context, CostoFijoModel costo) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar el costo "${costo.nombre}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Eliminar'),
            onPressed: () {
              Navigator.pop(context);
              controller.eliminarCostoFijo(costo.id);
            },
          ),
        ],
      ),
    );
  }
}