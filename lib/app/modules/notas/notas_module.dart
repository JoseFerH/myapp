// lib/app/modules/notas/notas_module.dart
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../data/models/nota_model.dart';
import '../../data/providers/notas_provider.dart';
import 'notas_view.dart';

// Servicio de Notas integrado
class NotasModuleService extends GetxService {
  final _notasProvider = NotasProvider();
  final RxList<NotaModel> notas = <NotaModel>[].obs;
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;

  Future<void> cargarNotas() async {
    try {
      cargando.value = true;
      List<NotaModel> lista = await _notasProvider.obtenerNotas();
      notas.assignAll(lista);
    } catch (e) {
      error.value = 'Error: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Resto de métodos CRUD...
}

// Controlador integrado de Notas
class NotasModuleController extends GetxController {
  final NotasModuleService _service = Get.find();
  final RxString filtroCategoria = 'Todas'.obs;
  final Rx<NotaModel?> notaSeleccionada = Rx<NotaModel?>(null);

  RxList<NotaModel> get notas => _service.notas;
  RxBool get cargando => _service.cargando;
  RxString get error => _service.error;

  @override
  void onInit() {
    super.onInit();
    _service.cargarNotas();
  }

  List<NotaModel> get notasFiltradas {
    if (filtroCategoria.value == 'Todas') {
      return notas;
    }
    return notas
        .where((nota) => nota.categoria == filtroCategoria.value)
        .toList();
  }

  // Resto de métodos CRUD que delegan al servicio...
}

// Binding integrado para Notas
class NotasModuleBinding extends Bindings {
  @override
  void dependencies() {
    // Crear el servicio y controlador de manera forzada (no lazy)
    Get.put(NotasModuleService(), permanent: true);
    Get.put(NotasModuleController(), permanent: true);
  }
}

// Función auxiliar para navegar a Notas con seguridad
Future<void> navegarANotas() async {
  try {
    // Asegurar que el módulo esté inicializado
    if (!Get.isRegistered<NotasModuleService>()) {
      Get.put(NotasModuleService(), permanent: true);
      Get.put(NotasModuleController(), permanent: true);

      // Cargar notas
      final service = Get.find<NotasModuleService>();
      await service.cargarNotas();
    }

    // Navegar
    Get.to(() => NotasModuleView(), binding: NotasModuleBinding());
  } catch (e) {
    print("Error al navegar a notas: $e");
    // Mostrar un mensaje de error al usuario
    Get.snackbar(
      'Error',
      'No se pudo abrir notas. Inténtelo de nuevo.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Vista integrada de Notas
class NotasModuleView extends GetView<NotasModuleController> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Mis Notas'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () => Get.back(),
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          if (controller.cargando.value) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${controller.error.value}'),
                  CupertinoButton(
                    child: Text('Reintentar'),
                    onPressed: () => controller._service.cargarNotas(),
                  ),
                ],
              ),
            );
          }

          // Resto de la implementación de la vista...
          return Center(child: Text('Vista de notas cargada con éxito'));
        }),
      ),
    );
  }
}
