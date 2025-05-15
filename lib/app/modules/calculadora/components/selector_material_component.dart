import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/calculadora_controller.dart';
import '../../../controllers/registros_controller.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../data/models/hoja_model.dart';
import '../../../data/models/laminado_model.dart';
import '../../../modules/registros/components/form_material_component.dart';
import '../../../data/models/material_model.dart'; // Importa TipoMaterial

class SelectorMaterialComponent extends GetView<CalculadoraController> {
  const SelectorMaterialComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculadoraController>(
      builder:
          (controller) => Container(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selección de Materiales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // Sección de Hojas
                  const Text(
                    'Hojas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  // Lista de hojas seleccionadas
                  Column(
                    children: [
                      // Mostrar las hojas ya seleccionadas
                      for (
                        int i = 0;
                        i < controller.hojasSeleccionadas.length;
                        i++
                      )
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildSelectorHoja(
                                  controller.hojasSeleccionadas[i],
                                  i,
                                  controller,
                                ),
                              ),

                              // Botón para agregar nueva hoja
                              CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                child: const Icon(
                                  CupertinoIcons.add_circled,
                                  color: CupertinoColors.activeBlue,
                                ),
                                onPressed:
                                    () => _mostrarFormularioMaterial(
                                      context,
                                      'hoja',
                                    ),
                              ),

                              // Botón para quitar esta hoja (solo si hay más de una)
                              if (controller.hojasSeleccionadas.length > 1)
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  child: const Icon(
                                    CupertinoIcons.minus_circled,
                                    color: CupertinoColors.systemRed,
                                  ),
                                  onPressed: () => controller.quitarHoja(i),
                                ),
                            ],
                          ),
                        ),

                      // Botón para agregar otra hoja si hay disponibles
                      if (controller.hayHojasDisponiblesParaSeleccionar)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(CupertinoIcons.add),
                              SizedBox(width: 8),
                              Text('Agregar otra hoja'),
                            ],
                          ),
                          onPressed: () => _mostrarSelectorHojas(context),
                        )
                      else if (controller.hojasSeleccionadas.isEmpty)
                        // Mensaje si no hay hojas seleccionadas
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'No hay hojas seleccionadas',
                                  style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                child: const Text('Seleccionar'),
                                onPressed: () => _mostrarSelectorHojas(context),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Sección de Laminados
                  const Text(
                    'Laminados',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  // Lista de laminados seleccionados
                  Column(
                    children: [
                      // Mostrar los laminados ya seleccionados
                      for (
                        int i = 0;
                        i < controller.laminadosSeleccionados.length;
                        i++
                      )
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildSelectorLaminado(
                                  controller.laminadosSeleccionados[i],
                                  i,
                                  controller,
                                ),
                              ),

                              // Botón para agregar nuevo laminado
                              CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                child: const Icon(
                                  CupertinoIcons.add_circled,
                                  color: CupertinoColors.activeBlue,
                                ),
                                onPressed:
                                    () => _mostrarFormularioMaterial(
                                      context,
                                      'laminado',
                                    ),
                              ),

                              // Botón para quitar este laminado (solo si hay más de uno)
                              if (controller.laminadosSeleccionados.length > 1)
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  child: const Icon(
                                    CupertinoIcons.minus_circled,
                                    color: CupertinoColors.systemRed,
                                  ),
                                  onPressed: () => controller.quitarLaminado(i),
                                ),
                            ],
                          ),
                        ),

                      // Botón para agregar otro laminado si hay disponibles
                      if (controller.hayLaminadosDisponiblesParaSeleccionar)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(CupertinoIcons.add),
                              SizedBox(width: 8),
                              Text('Agregar otro laminado'),
                            ],
                          ),
                          onPressed: () => _mostrarSelectorLaminados(context),
                        )
                      else if (controller.laminadosSeleccionados.isEmpty)
                        // Mensaje si no hay laminados seleccionados
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'No hay laminados seleccionados',
                                  style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                child: const Text('Seleccionar'),
                                onPressed:
                                    () => _mostrarSelectorLaminados(context),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // Widget para mostrar la información de una hoja seleccionada
  Widget _buildSelectorHoja(
    HojaModel hoja,
    int index,
    CalculadoraController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey4),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.doc,
            color: CupertinoColors.systemBlue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hoja.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Q${hoja.precioUnitario.toStringAsFixed(2)}',
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar la información de un laminado seleccionado
  Widget _buildSelectorLaminado(
    LaminadoModel laminado,
    int index,
    CalculadoraController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey4),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.layers,
            color: CupertinoColors.systemGreen,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              laminado.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Q${laminado.precioUnitario.toStringAsFixed(2)}',
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Mostrar selector de hojas disponibles
  void _mostrarSelectorHojas(BuildContext context) {
    // Filtrar las hojas no seleccionadas
    final hojasDisponibles =
        controller.hojas
            .where((h) => !controller.hojasSeleccionadasIds.contains(h.id))
            .toList();

    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Seleccionar Hoja',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Cerrar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Lista de hojas disponibles
                Expanded(
                  child: ListView.builder(
                    itemCount: hojasDisponibles.length,
                    itemBuilder: (context, index) {
                      final hoja = hojasDisponibles[index];
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: CupertinoColors.systemGrey5,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.doc,
                                color: CupertinoColors.systemBlue,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hoja.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      hoja.descripcion,
                                      style: const TextStyle(
                                        color: CupertinoColors.systemGrey,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Q${hoja.precioUnitario.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          controller.agregarHoja(hoja);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),

                // Botón para agregar nueva hoja
                CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  color: CupertinoColors.activeBlue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(CupertinoIcons.add),
                      SizedBox(width: 8),
                      Text('Agregar Nueva Hoja'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _mostrarFormularioMaterial(context, 'hoja');
                  },
                ),
              ],
            ),
          ),
    );
  }

  // Mostrar selector de laminados disponibles
  void _mostrarSelectorLaminados(BuildContext context) {
    // Filtrar los laminados no seleccionados
    final laminadosDisponibles =
        controller.laminados
            .where((l) => !controller.laminadosSeleccionadosIds.contains(l.id))
            .toList();

    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Seleccionar Laminado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Cerrar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Lista de laminados disponibles
                Expanded(
                  child: ListView.builder(
                    itemCount: laminadosDisponibles.length,
                    itemBuilder: (context, index) {
                      final laminado = laminadosDisponibles[index];
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: CupertinoColors.systemGrey5,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.layers,
                                color: CupertinoColors.systemGreen,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      laminado.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      laminado.descripcion,
                                      style: const TextStyle(
                                        color: CupertinoColors.systemGrey,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Q${laminado.precioUnitario.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          controller.agregarLaminado(laminado);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),

                // Botón para agregar nuevo laminado
                CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  color: CupertinoColors.activeBlue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(CupertinoIcons.add),
                      SizedBox(width: 8),
                      Text('Agregar Nuevo Laminado'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _mostrarFormularioMaterial(context, 'laminado');
                  },
                ),
              ],
            ),
          ),
    );
  }

  // Mostrar formulario para agregar un nuevo material
  void _mostrarFormularioMaterial(BuildContext context, String tipoMaterial) {
    // Get the necessary controller
    final registrosController = Get.find<RegistrosController>();

    // Show modal with material form
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            // Reemplazar toda la estructura actual con el FormMaterialComponent
            child: FormMaterialComponent(
              // Pasar null como material para indicar que es uno nuevo
              // El FormMaterialComponent ya maneja los títulos, campos y botones
              material: null,
              // Este es el cambio más importante - inicializar con el tipo correcto
              tipoInicial:
                  tipoMaterial == 'hoja'
                      ? TipoMaterial.hoja
                      : TipoMaterial.laminado,
            ),
          ),
    );
  }
}
