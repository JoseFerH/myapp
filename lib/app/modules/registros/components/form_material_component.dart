// lib/app/modules/registros/components/form_material_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/material_model.dart';
import '../../../data/models/hoja_model.dart';
import '../../../data/models/laminado_model.dart';

class FormMaterialComponent extends GetView<RegistrosController> {
  final MaterialModel? material;
  
  const FormMaterialComponent({Key? key, this.material}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controladores para los campos comunes
    final nombreController = TextEditingController(text: material?.nombre ?? '');
    final descripcionController = TextEditingController(text: material?.descripcion ?? '');
    final precioController = TextEditingController(
      text: material?.precioUnitario.toString() ?? '0.0',
    );
    final cantidadController = TextEditingController(
      text: material?.cantidadDisponible.toString() ?? '0',
    );
    final cantidadMinimaController = TextEditingController(
      text: material?.cantidadMinima.toString() ?? '5',
    );
    
    // Obtener fecha actual o fecha del material si existe
    final DateTime fechaInicial = material?.fechaCompra ?? DateTime.now();
    final fechaController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(fechaInicial),
    );
    
    // Variables para tipo de material y campos específicos
    Rx<TipoMaterial> tipoMaterial = Rx<TipoMaterial>(
      material?.tipo ?? TipoMaterial.hoja,
    );
    
    // Variables específicas para Hoja
    Rx<TipoHoja> tipoHoja = Rx<TipoHoja>(
      material is HojaModel ? (material as HojaModel).tipoHoja : TipoHoja.normal,
    );
    final tamanoController = TextEditingController(
      text: material is HojaModel ? (material as HojaModel).tamano : 'Carta',
    );
    
    // Variables específicas para Laminado
    Rx<TipoLaminado> tipoLaminado = Rx<TipoLaminado>(
      material is LaminadoModel ? (material as LaminadoModel).tipoLaminado : TipoLaminado.mate,
    );
    final grosorController = TextEditingController(
      text: material is LaminadoModel ? (material as LaminadoModel).grosor : 'Normal',
    );
    
    // Lista de proveedores disponibles
    final RxList<String> proveedoresIds = controller.proveedores
        .map((p) => p.id)
        .toList()
        .obs;
    final RxList<String> proveedoresNombres = controller.proveedores
        .map((p) => p.nombre)
        .toList()
        .obs;
        
    // Proveedor seleccionado
    final RxString proveedorId = (material?.proveedorId ?? 
        (proveedoresIds.isNotEmpty ? proveedoresIds.first : '')).obs;
    
    return Column(
      children: [
        // Barra superior
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                material == null ? 'Nuevo Material' : 'Editar Material',
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
                Obx(() => CupertinoSegmentedControl<TipoMaterial>(
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
                    tipoMaterial.value = value;
                  },
                )),
                
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
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  
                  int selectedIndex = proveedorId.value.isEmpty 
                      ? 0 
                      : proveedoresIds.indexOf(proveedorId.value);
                  
                  if (selectedIndex < 0) selectedIndex = 0;
                  
                  return GestureDetector(
                    onTap: () => _mostrarSelectorProveedor(
                      context, 
                      proveedoresNombres, 
                      proveedoresIds, 
                      proveedorId,
                    ),
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
                  onTap: () => _mostrarSelectorFecha(context, fechaController, fechaInicial),
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
                            tipoHoja.value = value;
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
                            tipoLaminado.value = value;
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
              if (material != null) ...[
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
                  child: Text(material == null ? 'Crear' : 'Actualizar'),
                  onPressed: () => _guardarMaterial(
                    context,
                    tipoMaterial.value,
                    nombreController.text,
                    descripcionController.text,
                    precioController.text,
                    cantidadController.text,
                    cantidadMinimaController.text,
                    proveedorId.value,
                    fechaController.text,
                    tipoHoja.value,
                    tamanoController.text,
                    tipoLaminado.value,
                    grosorController.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Mostrar selector de proveedor
  void _mostrarSelectorProveedor(
    BuildContext context,
    RxList<String> nombres,
    RxList<String> ids,
    RxString proveedorId,
  ) {
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
              'Seleccionar Proveedor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de proveedores
            Expanded(
              child: ListView.builder(
                itemCount: nombres.length,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      proveedorId.value = ids[index];
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(nombres[index]),
                        if (ids[index] == proveedorId.value)
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
  void _mostrarSelectorFecha(
    BuildContext context,
    TextEditingController fechaController,
    DateTime fechaInicial,
  ) {
    DateTime fechaSeleccionada = fechaInicial;
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Selector de fecha
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: fechaInicial,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime date) {
                  fechaSeleccionada = date;
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
                    fechaController.text = DateFormat('dd/MM/yyyy').format(fechaSeleccionada);
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
  void _guardarMaterial(
    BuildContext context,
    TipoMaterial tipo,
    String nombre,
    String descripcion,
    String precioText,
    String cantidadText,
    String cantidadMinimaText,
    String proveedorId,
    String fechaText,
    TipoHoja tipoHoja,
    String tamano,
    TipoLaminado tipoLaminado,
    String grosor,
  ) {
    // Validar campos obligatorios
    if (nombre.isEmpty || precioText.isEmpty || cantidadText.isEmpty || proveedorId.isEmpty) {
      Get.snackbar(
        'Error',
        'Nombre, precio, cantidad disponible y proveedor son obligatorios',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      // Convertir valores numéricos
      double precio = double.parse(precioText);
      int cantidad = int.parse(cantidadText);
      int cantidadMinima = int.parse(cantidadMinimaText);
      
      // Convertir fecha
      DateTime fecha;
      try {
        fecha = DateFormat('dd/MM/yyyy').parse(fechaText);
      } catch (e) {
        fecha = DateTime.now();
      }
      
      // Crear o actualizar según tipo de material
      if (tipo == TipoMaterial.hoja) {
        HojaModel hoja;
        
        if (material == null) {
          // Crear nueva hoja
          hoja = HojaModel(
            id: '',
            nombre: nombre,
            descripcion: descripcion,
            precioUnitario: precio,
            cantidadDisponible: cantidad,
            cantidadMinima: cantidadMinima,
            proveedorId: proveedorId,
            fechaCompra: fecha,
            tipoHoja: tipoHoja,
            tamano: tamano,
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
          if (material is HojaModel) {
            hoja = (material as HojaModel).copyWithHoja(
              nombre: nombre,
              descripcion: descripcion,
              precioUnitario: precio,
              cantidadDisponible: cantidad,
              cantidadMinima: cantidadMinima,
              proveedorId: proveedorId,
              fechaCompra: fecha,
              tipoHoja: tipoHoja,
              tamano: tamano,
            );
          } else {
            // Si el material era de otro tipo, crear uno nuevo
            hoja = HojaModel(
              id: material!.id,
              nombre: nombre,
              descripcion: descripcion,
              precioUnitario: precio,
              cantidadDisponible: cantidad,
              cantidadMinima: cantidadMinima,
              proveedorId: proveedorId,
              fechaCompra: fecha,
              tipoHoja: tipoHoja,
              tamano: tamano,
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
      } 
      else if (tipo == TipoMaterial.laminado) {
        LaminadoModel laminado;
        
        if (material == null) {
          // Crear nuevo laminado
          laminado = LaminadoModel(
            id: '',
            nombre: nombre,
            descripcion: descripcion,
            precioUnitario: precio,
            cantidadDisponible: cantidad,
            cantidadMinima: cantidadMinima,
            proveedorId: proveedorId,
            fechaCompra: fecha,
            tipoLaminado: tipoLaminado,
            grosor: grosor,
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
          if (material is LaminadoModel) {
            laminado = (material as LaminadoModel).copyWithLaminado(
              nombre: nombre,
              descripcion: descripcion,
              precioUnitario: precio,
              cantidadDisponible: cantidad,
              cantidadMinima: cantidadMinima,
              proveedorId: proveedorId,
              fechaCompra: fecha,
              tipoLaminado: tipoLaminado,
              grosor: grosor,
            );
          } else {
            // Si el material era de otro tipo, crear uno nuevo
            laminado = LaminadoModel(
              id: material!.id,
              nombre: nombre,
              descripcion: descripcion,
              precioUnitario: precio,
              cantidadDisponible: cantidad,
              cantidadMinima: cantidadMinima,
              proveedorId: proveedorId,
              fechaCompra: fecha,
              tipoLaminado: tipoLaminado,
              grosor: grosor,
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
      } 
      else {
        // Otros tipos de material
        MaterialModel nuevoMaterial;
        
        if (material == null) {
          // Crear nuevo material
          nuevoMaterial = MaterialModel(
            id: '',
            nombre: nombre,
            descripcion: descripcion,
            tipo: tipo,
            precioUnitario: precio,
            cantidadDisponible: cantidad,
            cantidadMinima: cantidadMinima,
            proveedorId: proveedorId,
            fechaCompra: fecha,
          );
        } else {
          // Actualizar material existente
          nuevoMaterial = material!.copyWith(
            nombre: nombre,
            descripcion: descripcion,
            tipo: tipo,
            precioUnitario: precio,
            cantidadDisponible: cantidad,
            cantidadMinima: cantidadMinima,
            proveedorId: proveedorId,
            fechaCompra: fecha,
          );
        }
        
        // Guardar material
        if (material == null) {
          // Si es un material genérico, usar el método de hojas (el servicio se encargará)
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
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar el material "${material!.nombre}"?'),
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
              
              controller.eliminarMaterial(material!.id).then((success) {
                if (success) {
                  Navigator.pop(context); // Cerrar el formulario
                  Get.snackbar(
                    'Éxito',
                    'Material eliminado correctamente',
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