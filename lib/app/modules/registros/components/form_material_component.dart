import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/material_model.dart';
import '../../../data/models/hoja_model.dart';
import '../../../data/models/laminado_model.dart';

class FormMaterialComponent extends StatefulWidget {
  final MaterialModel? material;
  final TipoMaterial? tipoInicial; // Añadir este parámetro

  const FormMaterialComponent({
    Key? key,
    this.material,
    this.tipoInicial, // Nuevo parámetro opcional
  }) : super(key: key);

  @override
  _FormMaterialComponentState createState() => _FormMaterialComponentState();
}

class _FormMaterialComponentState extends State<FormMaterialComponent> {
  // Controladores para los campos comunes
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController precioController;
  late TextEditingController cantidadController;
  late TextEditingController cantidadMinimaController;
  late TextEditingController fechaController;
  late TextEditingController tamanoController;
  late TextEditingController grosorController;

  // Variables para tipo de material y campos específicos
  late Rx<TipoMaterial> tipoMaterial;
  late Rx<TipoHoja> tipoHoja;
  late Rx<TipoLaminado> tipoLaminado;

  // Fecha seleccionada
  late DateTime fechaSeleccionada;

  // Proveedor seleccionado
  late RxString proveedorId;

  // Listas de proveedores
  late RxList<String> proveedoresIds;
  late RxList<String> proveedoresNombres;

  // Controlador de registros
  late RegistrosController controller;

  @override
  void initState() {
    super.initState();
    // Inicializar con tipoInicial si está presente, o usar el tipo del material existente, o el valor por defecto
    tipoMaterial = Rx<TipoMaterial>(
      widget.tipoInicial ?? widget.material?.tipo ?? TipoMaterial.hoja,
    );

    // Obtener el controlador
    controller = Get.find<RegistrosController>();

    // Inicializar controladores con valores del material si existe
    nombreController = TextEditingController(
      text: widget.material?.nombre ?? '',
    );
    descripcionController = TextEditingController(
      text: widget.material?.descripcion ?? '',
    );
    precioController = TextEditingController(
      text: widget.material?.precioUnitario.toString() ?? '0.0',
    );
    cantidadController = TextEditingController(
      text: widget.material?.cantidadDisponible.toString() ?? '0',
    );
    cantidadMinimaController = TextEditingController(
      text: widget.material?.cantidadMinima.toString() ?? '5',
    );

    // Obtener fecha del material o actual
    fechaSeleccionada = widget.material?.fechaCompra ?? DateTime.now();
    fechaController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(fechaSeleccionada),
    );

    // Inicializar variables específicas para tipos de material
    tipoMaterial = Rx<TipoMaterial>(widget.material?.tipo ?? TipoMaterial.hoja);

    tipoHoja = Rx<TipoHoja>(
      widget.material is HojaModel
          ? (widget.material as HojaModel).tipoHoja
          : TipoHoja.normal,
    );
    tamanoController = TextEditingController(
      text:
          widget.material is HojaModel
              ? (widget.material as HojaModel).tamano
              : 'Carta',
    );

    tipoLaminado = Rx<TipoLaminado>(
      widget.material is LaminadoModel
          ? (widget.material as LaminadoModel).tipoLaminado
          : TipoLaminado.mate,
    );
    grosorController = TextEditingController(
      text:
          widget.material is LaminadoModel
              ? (widget.material as LaminadoModel).grosor
              : 'Normal',
    );

    // Lista de proveedores disponibles
    proveedoresIds = controller.proveedores.map((p) => p.id).toList().obs;
    proveedoresNombres =
        controller.proveedores.map((p) => p.nombre).toList().obs;

    // Proveedor seleccionado
    proveedorId =
        (widget.material?.proveedorId ??
                (proveedoresIds.isNotEmpty ? proveedoresIds.first : ''))
            .obs;
  }

  @override
  void dispose() {
    // Liberar recursos al desmontar el widget
    nombreController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    cantidadController.dispose();
    cantidadMinimaController.dispose();
    fechaController.dispose();
    tamanoController.dispose();
    grosorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra superior
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.material == null ? 'Nuevo Material' : 'Editar Material',
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

        // Contenido del formulario
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipo de Material
                const Text('Tipo de Material'),
                const SizedBox(height: 8),

                // Selector de tipo de material
                Obx(
                  () => CupertinoSegmentedControl<TipoMaterial>(
                    children: const {
                      TipoMaterial.hoja: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Hoja'),
                      ),
                      TipoMaterial.laminado: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Laminado'),
                      ),
                      TipoMaterial.tinta: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Tinta'),
                      ),
                      TipoMaterial.otros: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Otros'),
                      ),
                    },
                    groupValue: tipoMaterial.value,
                    onValueChanged: (value) {
                      setState(() {
                        tipoMaterial.value = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Campos comunes
                const Text('Nombre'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: nombreController,
                  placeholder: 'Nombre del material',
                  padding: const EdgeInsets.all(12),
                ),

                const SizedBox(height: 16),

                const Text('Descripción'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: descripcionController,
                  placeholder: 'Descripción del material',
                  padding: const EdgeInsets.all(12),
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                const Text('Precio Unitario (Q)'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: precioController,
                  placeholder: '0.00',
                  padding: const EdgeInsets.all(12),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Q'),
                  ),
                ),

                const SizedBox(height: 16),

                // Fila de cantidad disponible y mínima
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cantidad Disponible'),
                          const SizedBox(height: 8),
                          CupertinoTextField(
                            controller: cantidadController,
                            placeholder: '0',
                            padding: const EdgeInsets.all(12),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cantidad Mínima'),
                          const SizedBox(height: 8),
                          CupertinoTextField(
                            controller: cantidadMinimaController,
                            placeholder: '5',
                            padding: const EdgeInsets.all(12),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Selector de proveedor
                const Text('Proveedor'),
                const SizedBox(height: 8),

                Obx(() {
                  if (proveedoresNombres.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CupertinoColors.systemGrey4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'No hay proveedores disponibles',
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                          Icon(
                            CupertinoIcons.chevron_down,
                            size: 16,
                            color: CupertinoColors.systemGrey,
                          ),
                        ],
                      ),
                    );
                  }

                  int selectedIndex =
                      proveedorId.value.isEmpty
                          ? 0
                          : proveedoresIds.indexOf(proveedorId.value);

                  if (selectedIndex < 0) selectedIndex = 0;

                  return GestureDetector(
                    onTap: () => _mostrarSelectorProveedor(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CupertinoColors.systemGrey4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(proveedoresNombres[selectedIndex]),
                          const Icon(
                            CupertinoIcons.chevron_down,
                            size: 16,
                            color: CupertinoColors.systemGrey,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Fecha de compra
                const Text('Fecha de Compra'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _mostrarSelectorFecha(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: CupertinoColors.systemGrey4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fechaController.text),
                        const Icon(
                          CupertinoIcons.calendar,
                          size: 20,
                          color: CupertinoColors.systemGrey,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Campos específicos según tipo de material
                Obx(() {
                  // Campos para Hoja
                  if (tipoMaterial.value == TipoMaterial.hoja) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Propiedades Específicas de Hoja',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text('Tipo de Hoja'),
                        const SizedBox(height: 8),
                        CupertinoSegmentedControl<TipoHoja>(
                          children: const {
                            TipoHoja.normal: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Normal'),
                            ),
                            TipoHoja.premium: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Premium'),
                            ),
                            TipoHoja.especial: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Especial'),
                            ),
                          },
                          groupValue: tipoHoja.value,
                          onValueChanged: (value) {
                            setState(() {
                              tipoHoja.value = value;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        const Text('Tamaño'),
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: tamanoController,
                          placeholder: 'Ej: Carta, Oficio, etc.',
                          padding: const EdgeInsets.all(12),
                        ),
                      ],
                    );
                  }
                  // Campos para Laminado
                  else if (tipoMaterial.value == TipoMaterial.laminado) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Propiedades Específicas de Laminado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text('Tipo de Laminado'),
                        const SizedBox(height: 8),
                        CupertinoSegmentedControl<TipoLaminado>(
                          children: const {
                            TipoLaminado.mate: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Mate'),
                            ),

                            TipoLaminado.brillante: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Brillante'),
                            ),
                            TipoLaminado.texturizado: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Texturizado'),
                            ),
                          },
                          groupValue: tipoLaminado.value,
                          onValueChanged: (value) {
                            setState(() {
                              tipoLaminado.value = value;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        const Text('Grosor'),
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: grosorController,
                          placeholder: 'Ej: Normal, Grueso, etc.',
                          padding: const EdgeInsets.all(12),
                        ),
                      ],
                    );
                  }

                  // No hay campos específicos para otros tipos
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),

        // Botones de acción
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (widget.material != null) ...[
                // Botón Eliminar (solo en modo edición)
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(12),
                    color: CupertinoColors.systemRed,
                    child: const Text('Eliminar'),
                    onPressed: () => _confirmarEliminar(context),
                  ),
                ),

                const SizedBox(width: 16),
              ],

              // Botón Guardar
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  color: CupertinoColors.activeBlue,
                  child: Text(widget.material == null ? 'Crear' : 'Actualizar'),
                  onPressed: () => _guardarMaterial(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Mostrar selector de proveedor
  void _mostrarSelectorProveedor(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
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
                  'Seleccionar Proveedor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // Lista de proveedores
                Expanded(
                  child: ListView.builder(
                    itemCount: proveedoresNombres.length,
                    itemBuilder: (context, index) {
                      return CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onPressed: () {
                          setState(() {
                            proveedorId.value = proveedoresIds[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(proveedoresNombres[index]),
                            if (proveedoresIds[index] == proveedorId.value)
                              const Icon(
                                CupertinoIcons.check_mark,
                                color: CupertinoColors.activeBlue,
                              ),
                          ],
                        ),
                      );
                    },
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

  // Mostrar selector de fecha
  void _mostrarSelectorFecha(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Seleccionar Fecha',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // Selector de fecha
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: fechaSeleccionada,
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime date) {
                      setState(() {
                        fechaSeleccionada = date;
                      });
                    },
                  ),
                ),

                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        setState(() {
                          fechaController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(fechaSeleccionada);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  // Guardar material (crear nuevo o actualizar existente)
  void _guardarMaterial(BuildContext context) {
    // Validar campos obligatorios
    if (nombreController.text.isEmpty ||
        precioController.text.isEmpty ||
        cantidadController.text.isEmpty ||
        proveedorId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Nombre, precio, cantidad disponible y proveedor son obligatorios',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Convertir valores numéricos
      double precio = double.parse(precioController.text);
      int cantidad = int.parse(cantidadController.text);
      int cantidadMinima = int.parse(cantidadMinimaController.text);

      // Convertir fecha
      DateTime fecha;
      try {
        fecha = DateFormat('dd/MM/yyyy').parse(fechaController.text);
      } catch (e) {
        fecha = DateTime.now();
      }

      // Crear o actualizar según tipo de material
      if (tipoMaterial.value == TipoMaterial.hoja) {
        HojaModel hoja;

        if (widget.material == null) {
          // Crear nueva hoja
          hoja = HojaModel(
            id: '',
            nombre: nombreController.text,
            descripcion: descripcionController.text,
            precioUnitario: precio,
            cantidadDisponible: cantidad,
            cantidadMinima: cantidadMinima,
            proveedorId: proveedorId.value,
            fechaCompra: fecha,
            tipoHoja: tipoHoja.value,
            tamano: tamanoController.text,
          );

          controller.crearHoja(hoja).then((success) {
            if (success) {
              Navigator.pop(context);
              Get.snackbar(
                'Éxito',
                'Material creado correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          });
        } else {
          // Actualizar hoja existente
          if (widget.material is HojaModel) {
            hoja = (widget.material as HojaModel).copyWithHoja(
              nombre: nombreController.text,
              descripcion: descripcionController.text,
              precioUnitario: precio,
              cantidadDisponible: cantidad,
              cantidadMinima: cantidadMinima,
              proveedorId: proveedorId.value,
              fechaCompra: fecha,
              tipoHoja: tipoHoja.value,
              tamano: tamanoController.text,
            );
          } else {
            // Si el material era de otro tipo, crear uno nuevo
            hoja = HojaModel(
              id: widget.material!.id,
              nombre: nombreController.text,
              descripcion: descripcionController.text,
              precioUnitario: precio,
              cantidadDisponible: cantidad,
              cantidadMinima: cantidadMinima,
              proveedorId: proveedorId.value,
              fechaCompra: fecha,
              tipoHoja: tipoHoja.value,
              tamano: tamanoController.text,
            );
          }

          controller.actualizarMaterial(hoja).then((success) {
            if (success) {
              Navigator.pop(context);
              Get.snackbar(
                'Éxito',
                'Material actualizado correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          });
        }
      } else if (tipoMaterial.value == TipoMaterial.laminado) {
        LaminadoModel laminado;

        if (widget.material == null) {
          // Crear nuevo laminado
          laminado = LaminadoModel(
            id: '',
            nombre: nombreController.text,
            descripcion: descripcionController.text,
            precioUnitario: precio,
            cantidadDisponible: cantidad,
            cantidadMinima: cantidadMinima,
            proveedorId: proveedorId.value,
            fechaCompra: fecha,
            tipoLaminado: tipoLaminado.value,
            grosor: grosorController.text,
          );

          controller.crearLaminado(laminado).then((success) {
            if (success) {
              Navigator.pop(context);
              Get.snackbar(
                'Éxito',
                'Material creado correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          });
        } else {
          // Actualizar laminado existente
          if (widget.material is LaminadoModel) {
            laminado = (widget.material as LaminadoModel).copyWithLaminado(
              nombre: nombreController.text,
              descripcion: descripcionController.text,
              precioUnitario: precio,
              cantidadDisponible: cantidad,
              cantidadMinima: cantidadMinima,
              proveedorId: proveedorId.value,
              fechaCompra: fecha,
              tipoLaminado: tipoLaminado.value,
              grosor: grosorController.text,
            );
          } else {
            // Si el material era de otro tipo, crear uno nuevo
            laminado = LaminadoModel(
              id: widget.material!.id,
              nombre: nombreController.text,
              descripcion: descripcionController.text,
              precioUnitario: precio,
              cantidadDisponible: cantidad,
              cantidadMinima: cantidadMinima,
              proveedorId: proveedorId.value,
              fechaCompra: fecha,
              tipoLaminado: tipoLaminado.value,
              grosor: grosorController.text,
            );
          }

          controller.actualizarMaterial(laminado).then((success) {
            if (success) {
              Navigator.pop(context);
              Get.snackbar(
                'Éxito',
                'Material actualizado correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          });
        }
      } else {
        // Otros tipos de material
        MaterialModel nuevoMaterial;

        if (widget.material == null) {
          // Crear nuevo material
          nuevoMaterial = MaterialModel(
            id: '',
            nombre: nombreController.text,
            descripcion: descripcionController.text,
            tipo: tipoMaterial.value,
            precioUnitario: precio,
            cantidadDisponible: cantidad,
            cantidadMinima: cantidadMinima,
            proveedorId: proveedorId.value,
            fechaCompra: fecha,
          );
        } else {
          // Actualizar material existente
          nuevoMaterial = widget.material!.copyWith(
            nombre: nombreController.text,
            descripcion: descripcionController.text,
            tipo: tipoMaterial.value,
            precioUnitario: precio,
            cantidadDisponible: cantidad,
            cantidadMinima: cantidadMinima,
            proveedorId: proveedorId.value,
            fechaCompra: fecha,
          );
        }

        // Guardar material
        if (widget.material == null) {
          // Si es un material genérico, usar el método crear
          controller.crearHoja(nuevoMaterial as HojaModel).then((success) {
            if (success) {
              Navigator.pop(context);
              Get.snackbar(
                'Éxito',
                'Material creado correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          });
        } else {
          controller.actualizarMaterial(nuevoMaterial).then((success) {
            if (success) {
              Navigator.pop(context);
              Get.snackbar(
                'Éxito',
                'Material actualizado correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Verifique los valores ingresados: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Confirmar eliminación de material
  void _confirmarEliminar(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar el material "${widget.material!.nombre}"?',
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

                  controller.eliminarMaterial(widget.material!.id).then((
                    success,
                  ) {
                    if (success) {
                      Navigator.pop(context); // Cerrar el formulario
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
