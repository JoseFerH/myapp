// lib/app/modules/calculadora/components/selector_cliente_calculadora_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/calculadora_controller.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/cliente_model.dart';

class SelectorClienteCalculadoraComponent
    extends GetView<CalculadoraController> {
  const SelectorClienteCalculadoraComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Selector de cliente
            GestureDetector(
              onTap: () => _mostrarSelectorClientes(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        controller.clienteSeleccionado.value != null
                            ? controller.clienteSeleccionado.value!.nombre
                            : 'Seleccionar Cliente',
                        style: TextStyle(
                          color:
                              controller.clienteSeleccionado.value != null
                                  ? CupertinoColors.black
                                  : CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.chevron_down,
                      size: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botón para agregar nuevo cliente
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.person_add, size: 20),
                  SizedBox(width: 8),
                  Text('Agregar Nuevo Cliente'),
                ],
              ),
              onPressed: () => _mostrarFormularioCliente(context),
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar selector de clientes en un modal
  void _mostrarSelectorClientes(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
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
                    'Seleccionar Cliente',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Cerrar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Barra de búsqueda
              CupertinoSearchTextField(
                placeholder: 'Buscar cliente',
                onChanged: (String value) {
                  // Implementar búsqueda
                  controller.filtrarClientes(value);
                },
              ),

              const SizedBox(height: 16),

              // Lista de clientes
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.clientesFiltrados.length,
                    itemBuilder: (context, index) {
                      final cliente = controller.clientesFiltrados[index];
                      return _buildClienteItem(context, cliente);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Construir ítem de cliente en la lista
  Widget _buildClienteItem(BuildContext context, ClienteModel cliente) {
    return GestureDetector(
      onTap: () {
        controller.seleccionarCliente(cliente);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.person,
              color: CupertinoColors.systemGrey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cliente.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Zona: ${cliente.zona} • ${cliente.tipoCliente}',
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () =>
                  controller.clienteSeleccionado.value?.id == cliente.id
                      ? const Icon(
                        CupertinoIcons.check_mark,
                        color: CupertinoColors.activeBlue,
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar formulario para agregar nuevo cliente
  void _mostrarFormularioCliente(BuildContext context) {
    // Variables para el formulario
    final nombreController = TextEditingController();
    final direccionController = TextEditingController();
    final zonaController = TextEditingController();
    String tipoCliente = 'Regular';

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
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
                    'Nuevo Cliente',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Formulario
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nombre'),
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: nombreController,
                        placeholder: 'Nombre completo',
                        padding: const EdgeInsets.all(12),
                      ),

                      const SizedBox(height: 16),

                      const Text('Dirección'),
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: direccionController,
                        placeholder: 'Dirección completa',
                        padding: const EdgeInsets.all(12),
                      ),

                      const SizedBox(height: 16),

                      const Text('Zona'),
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: zonaController,
                        placeholder: 'Zona (ej: Zona 10)',
                        padding: const EdgeInsets.all(12),
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 16),

                      const Text('Tipo de Cliente'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CupertinoColors.systemGrey4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return CupertinoSegmentedControl<String>(
                              children: const {
                                'Regular': Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('Regular'),
                                ),
                                'Frecuente': Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('Frecuente'),
                                ),
                                'VIP': Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('VIP'),
                                ),
                              },
                              groupValue: tipoCliente,
                              onValueChanged: (value) {
                                setState(() => tipoCliente = value);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botón de guardar
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: const Text('Guardar Cliente'),
                  onPressed: () {
                    // Validar campos
                    if (nombreController.text.isEmpty ||
                        direccionController.text.isEmpty ||
                        zonaController.text.isEmpty) {
                      // Mostrar error
                      showCupertinoDialog(
                        context: context,
                        builder:
                            (context) => CupertinoAlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                'Todos los campos son obligatorios',
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                      );
                      return;
                    }

                    // Crear cliente
                    final cliente = ClienteModel(
                      nombre: nombreController.text,
                      direccion: direccionController.text,
                      zona: zonaController.text,
                      tipoCliente: tipoCliente,
                    );

                    // Guardar cliente y cerrar modal
                    Get.find<RegistrosController>().crearCliente(cliente).then((
                      success,
                    ) {
                      if (success) {
                        controller.cargarClientes().then((_) {
                          controller.seleccionarCliente(
                            controller.clientesFiltrados.firstWhere(
                              (c) => c.nombre == cliente.nombre,
                            ),
                          );
                          Navigator.pop(context);
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
