// lib/app/modules/registros/views/inventario_view.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/material_model.dart';
import '../../../data/models/hoja_model.dart';
import '../../../data/models/laminado_model.dart';
import '../../../widgets/empty_state.dart';
import '../components/form_material_component.dart';
import 'package:intl/intl.dart';

class InventarioView extends GetView<RegistrosController> {
  const InventarioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selector de tipo de material
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoSegmentedControl<int>(
            children: const {
              0: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Todos'),
              ),
              1: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Hojas'),
              ),
              2: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Laminados'),
              ),
              3: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Otros'),
              ),
            },
            onValueChanged: (int value) {
              // Implementar filtrado por tipo
            },
            groupValue: 0, // Por defecto mostrar todos
          ),
        ),

        // Lista de materiales
        Expanded(
          child: Stack(
            children: [
              Obx(() {
                final materiales = controller.materialesFiltrados;

                if (materiales.isEmpty) {
                  return EmptyState(
                    title: 'No hay materiales',
                    message: 'Agrega tu primer material para comenzar',
                    icon: CupertinoIcons.cube_box,
                    buttonText: 'Agregar Material',
                    onButtonPressed: () => _mostrarFormularioMaterial(context),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: 80,
                  ), // Espacio para el botón flotante
                  itemCount: materiales.length,
                  separatorBuilder: (context, index) => Container(height: 1),
                  itemBuilder: (context, index) {
                    final material = materiales[index];
                    return _buildMaterialItem(context, material);
                  },
                );
              }),

              // Botón flotante para agregar
              Positioned(
                right: 16,
                bottom: 16,
                child: CupertinoButton(
                  padding: const EdgeInsets.all(
                    0,
                  ), // Reducir padding para que el botón sea más compacto
                  color: CupertinoColors.activeBlue,
                  // borderRadius: BorderRadius.circular(
                  //   30,
                  // ), // Hacer el botón más circular
                  // Aquí está el cambio - usar directamente el método que ya existe
                  onPressed: () => _mostrarFormularioMaterial(context),
                  child: const SizedBox(
                    width: 56, // Ancho fijo para el botón circular
                    height: 56, // Alto fijo para el botón circular
                    child: Center(
                      child: Icon(
                        CupertinoIcons.add,
                        color:
                            CupertinoColors
                                .white, // Garantizar que el icono sea BLANCO
                        size:
                            30, // Aumentar tamaño del icono para mejor visibilidad
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Construir item de material
  Widget _buildMaterialItem(BuildContext context, MaterialModel material) {
    // Determinar icono y color según tipo de material
    IconData icono;
    Color color;

    switch (material.tipo) {
      case TipoMaterial.hoja:
        icono = CupertinoIcons.doc;
        color = CupertinoColors.systemBlue;
        break;
      case TipoMaterial.laminado:
        icono = CupertinoIcons.layers;
        color = CupertinoColors.systemGreen;
        break;
      case TipoMaterial.tinta:
        icono = CupertinoIcons.drop;
        color = CupertinoColors.systemPurple;
        break;
      case TipoMaterial.otros:
      default:
        icono = CupertinoIcons.cube_box;
        color = CupertinoColors.systemGrey;
        break;
    }

    // Determinar si el stock es bajo
    bool stockBajo = material.esBajoStock;

    return GestureDetector(
      onTap: () => _mostrarDetalleMaterial(context, material),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: CupertinoColors.white,
        child: Row(
          children: [
            // Icono según tipo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icono, color: color, size: 25),
            ),

            const SizedBox(width: 16),

            // Información principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    material.descripcion,
                    style: const TextStyle(color: CupertinoColors.systemGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Precio unitario
                      Text(
                        'Q${material.precioUnitario.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.systemIndigo,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Indicador de stock
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              stockBajo
                                  ? CupertinoColors.systemRed.withOpacity(0.1)
                                  : CupertinoColors.systemGreen.withOpacity(
                                    0.1,
                                  ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Stock: ${material.cantidadDisponible}',
                          style: TextStyle(
                            color:
                                stockBajo
                                    ? CupertinoColors.systemRed
                                    : CupertinoColors.systemGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Flecha de navegación
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar formulario de material
  void _mostrarFormularioMaterial(
    BuildContext context, [
    MaterialModel? material,
  ]) {
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
            child: FormMaterialComponent(material: material),
          ),
    );
  }

  // Mostrar detalle de material
  void _mostrarDetalleMaterial(BuildContext context, MaterialModel material) {
    controller.materialSeleccionado.value = material;

    // Determinar título específico según tipo
    String titulo;
    if (material is HojaModel) {
      titulo = 'Detalle de Hoja';
    } else if (material is LaminadoModel) {
      titulo = 'Detalle de Laminado';
    } else {
      titulo = 'Detalle de Material';
    }

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
            child: Column(
              children: [
                // Barra superior
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
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
                ),

                // Contenido
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Información básica del material
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: CupertinoColors.systemGrey5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Nombre:', material.nombre),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Descripción:',
                                material.descripcion,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Tipo:',
                                _obtenerTipoTexto(material.tipo),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Precio Unitario:',
                                'Q${material.precioUnitario.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Stock Disponible:',
                                '${material.cantidadDisponible} unidades',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Stock Mínimo:',
                                '${material.cantidadMinima} unidades',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Fecha de Compra:',
                                DateFormat(
                                  'dd/MM/yyyy',
                                ).format(material.fechaCompra),
                              ),

                              // Información específica según tipo de material
                              if (material is HojaModel) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  'Tipo de Hoja:',
                                  _obtenerTipoHojaTexto(material.tipoHoja),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow('Tamaño:', material.tamano),
                              ] else if (material is LaminadoModel) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  'Tipo de Laminado:',
                                  _obtenerTipoLaminadoTexto(
                                    material.tipoLaminado,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow('Grosor:', material.grosor),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Acciones de inventario
                        const Text(
                          'Gestión de Inventario',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Botones para agregar/reducir stock
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(12),
                                color: CupertinoColors.systemGreen,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(CupertinoIcons.plus),
                                    SizedBox(width: 8),
                                    Text('Agregar Stock'),
                                  ],
                                ),
                                onPressed:
                                    () => _mostrarDialogoAgregarStock(
                                      context,
                                      material,
                                    ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(12),
                                color: CupertinoColors.systemRed,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(CupertinoIcons.minus),
                                    SizedBox(width: 8),
                                    Text('Reducir Stock'),
                                  ],
                                ),
                                onPressed:
                                    () => _mostrarDialogoReducirStock(
                                      context,
                                      material,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Botones de acción
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Botón Editar
                      Expanded(
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(12),
                          color: CupertinoColors.activeBlue,
                          child: const Text('Editar'),
                          onPressed: () {
                            Navigator.pop(context);
                            _mostrarFormularioMaterial(context, material);
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Botón Eliminar
                      Expanded(
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(12),
                          color: CupertinoColors.systemGrey,
                          child: const Text('Eliminar'),
                          onPressed:
                              () =>
                                  _confirmarEliminarMaterial(context, material),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Mostrar diálogo para agregar stock
  void _mostrarDialogoAgregarStock(
    BuildContext context,
    MaterialModel material,
  ) {
    final cantidadController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Agregar Stock'),
            content: Column(
              children: [
                const SizedBox(height: 16),
                const Text('Ingrese la cantidad a agregar:'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  placeholder: 'Cantidad',
                  autofocus: true,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Agregar'),
                onPressed: () {
                  if (cantidadController.text.isNotEmpty) {
                    try {
                      int cantidad = int.parse(cantidadController.text);
                      if (cantidad > 0) {
                        controller.aumentarStock(material.id, cantidad).then((
                          success,
                        ) {
                          if (success) {
                            Navigator.pop(context); // Cerrar diálogo
                            Navigator.pop(context); // Cerrar detalle
                            Get.snackbar(
                              'Éxito',
                              'Stock actualizado correctamente',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        });
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Ingrese un número válido',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                },
              ),
            ],
          ),
    );
  }

  // Mostrar diálogo para reducir stock
  void _mostrarDialogoReducirStock(
    BuildContext context,
    MaterialModel material,
  ) {
    final cantidadController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Reducir Stock'),
            content: Column(
              children: [
                const SizedBox(height: 16),
                const Text('Ingrese la cantidad a reducir:'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  placeholder: 'Cantidad',
                  autofocus: true,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Reducir'),
                onPressed: () {
                  if (cantidadController.text.isNotEmpty) {
                    try {
                      int cantidad = int.parse(cantidadController.text);
                      if (cantidad > 0) {
                        if (cantidad <= material.cantidadDisponible) {
                          controller.reducirStock(material.id, cantidad).then((
                            success,
                          ) {
                            if (success) {
                              Navigator.pop(context); // Cerrar diálogo
                              Navigator.pop(context); // Cerrar detalle
                              Get.snackbar(
                                'Éxito',
                                'Stock actualizado correctamente',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          });
                        } else {
                          Get.snackbar(
                            'Error',
                            'La cantidad a reducir no puede ser mayor al stock disponible',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Ingrese un número válido',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                },
              ),
            ],
          ),
    );
  }

  // Construir fila de información
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  // Obtener texto de tipo de material
  String _obtenerTipoTexto(TipoMaterial tipo) {
    switch (tipo) {
      case TipoMaterial.hoja:
        return 'Hoja';
      case TipoMaterial.laminado:
        return 'Laminado';
      case TipoMaterial.tinta:
        return 'Tinta';
      case TipoMaterial.otros:
      default:
        return 'Otro';
    }
  }

  // Obtener texto de tipo de hoja
  String _obtenerTipoHojaTexto(TipoHoja tipo) {
    switch (tipo) {
      case TipoHoja.normal:
        return 'Normal';
      case TipoHoja.premium:
        return 'Premium';
      case TipoHoja.especial:
        return 'Especial';
      default:
        return 'Desconocido';
    }
  }

  // Obtener texto de tipo de laminado
  String _obtenerTipoLaminadoTexto(TipoLaminado tipo) {
    switch (tipo) {
      case TipoLaminado.mate:
        return 'Mate';
      case TipoLaminado.brillante:
        return 'Brillante';
      case TipoLaminado.texturizado:
        return 'Texturizado';
      default:
        return 'Desconocido';
    }
  }

  // Confirmar eliminación de material
  void _confirmarEliminarMaterial(
    BuildContext context,
    MaterialModel material,
  ) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar el material "${material.nombre}"?',
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Eliminar'),
                onPressed: () {
                  Navigator.pop(context); // Cerrar el diálogo

                  controller.eliminarMaterial(material.id).then((success) {
                    if (success) {
                      Navigator.pop(context); // Cerrar el modal de detalle
                      Get.snackbar(
                        'Éxito',
                        'Material eliminado correctamente',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        controller.error.value,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  });
                },
              ),
            ],
          ),
    );
  }
}
