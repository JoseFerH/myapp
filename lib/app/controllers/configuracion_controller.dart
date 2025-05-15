import 'package:get/get.dart';
import '../data/models/configuracion_model.dart';
import '../data/models/costo_fijo_model.dart';
import '../data/providers/configuracion_provider.dart';
import '../data/models/proyecto_model.dart';
import '../data/providers/proyectos_provider.dart';

class ConfiguracionController extends GetxController {
  // Provider
  final ConfiguracionProvider _configProvider =
      Get.find<ConfiguracionProvider>();

  // Variables reactivas de UI
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  final RxInt tabIndex = 0.obs; // Tab index for the segmented control

  // Variables reactivas para configuración
  final Rx<ConfiguracionModel?> configuracion = Rx<ConfiguracionModel?>(null);
  final RxList<CostoFijoModel> costosFijos = <CostoFijoModel>[].obs;

  // Variables para edición
  final RxDouble porcentajeGananciasMin = 50.0.obs;
  final RxDouble porcentajeGananciasDefault = 50.0.obs;
  final RxDouble precioDisenioEstandar = 0.0.obs;
  final RxDouble precioDisenioPersonalizado = 50.0.obs;
  final RxDouble costoEnvioNormal = 18.0.obs;
  final RxDouble costoEnvioExpress = 30.0.obs;
  final RxBool aplicarDesperdicioDefault = true.obs;
  final RxDouble porcentajeDesperdicio = 5.0.obs;
  final RxDouble precioCuartoHoja = 20.0.obs;
  final RxDouble precioMediaHoja = 15.0.obs;
  final RxDouble precioRedesSociales = 90.0.obs;
  final RxDouble precioMayorista = 10.0.obs;
  final RxInt cantidadMayorista = 100.obs;
  final RxList<ProyectoModel> proyectos = <ProyectoModel>[].obs;
  final ProyectosProvider _proyectosProvider = ProyectosProvider();

  @override
  void onInit() async {
    super.onInit();
    await cargarConfiguracion();
    await cargarCostosFijos();
    cargarProyectos();
  }

  // Method to change the selected tab
  void cambiarTab(int index) {
    tabIndex.value = index;
  }

  // Método para cargar proyectos
  Future<void> cargarProyectos() async {
    try {
      List<ProyectoModel> listaProyectos =
          await _proyectosProvider.obtenerProyectos();
      proyectos.assignAll(listaProyectos);
    } catch (e) {
      error.value = 'Error al cargar proyectos: $e';
    }
  }

  // Métodos para CRUD de proyectos
  Future<bool> guardarProyecto(ProyectoModel proyecto) async {
    try {
      if (proyecto.id.isEmpty) {
        await _proyectosProvider.crearProyecto(proyecto);
      } else {
        await _proyectosProvider.actualizarProyecto(proyecto);
      }
      await cargarProyectos();
      return true;
    } catch (e) {
      error.value = 'Error al guardar proyecto: $e';
      return false;
    }
  }

  Future<bool> eliminarProyecto(String id) async {
    try {
      await _proyectosProvider.eliminarProyecto(id);
      await cargarProyectos();
      return true;
    } catch (e) {
      error.value = 'Error al eliminar proyecto: $e';
      return false;
    }
  }

  Future<bool> toggleProyecto(String id, bool activo) async {
    try {
      await _proyectosProvider.toggleProyecto(id, activo);
      await cargarProyectos();
      return true;
    } catch (e) {
      error.value = 'Error al cambiar estado del proyecto: $e';
      return false;
    }
  }

  // Cargar configuración global
  Future<void> cargarConfiguracion() async {
    try {
      cargando.value = true;
      error.value = '';

      ConfiguracionModel config = await _configProvider.obtenerConfiguracion();
      configuracion.value = config;

      // Actualizar variables reactivas
      porcentajeGananciasMin.value = config.porcentajeGananciasMin;
      porcentajeGananciasDefault.value = config.porcentajeGananciasDefault;
      precioDisenioEstandar.value = config.precioDisenioEstandar;
      precioDisenioPersonalizado.value = config.precioDisenioPersonalizado;
      costoEnvioNormal.value = config.costoEnvioNormal;
      costoEnvioExpress.value = config.costoEnvioExpress;
      aplicarDesperdicioDefault.value = config.aplicarDesperdicioDefault;
      porcentajeDesperdicio.value = config.porcentajeDesperdicio;
      precioCuartoHoja.value = config.precioCuartoHoja;
      precioMediaHoja.value = config.precioMediaHoja;
      precioRedesSociales.value = config.precioRedesSociales;
      precioMayorista.value = config.precioMayorista;
      cantidadMayorista.value = config.cantidadMayorista;
    } catch (e) {
      error.value = 'Error al cargar configuración: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Cargar costos fijos
  Future<void> cargarCostosFijos() async {
    try {
      cargando.value = true;
      error.value = '';

      List<CostoFijoModel> costos = await _configProvider.obtenerCostosFijos();
      costosFijos.assignAll(costos);
    } catch (e) {
      error.value = 'Error al cargar costos fijos: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Guardar configuración
  Future<void> guardarConfiguracion() async {
    try {
      cargando.value = true;
      error.value = '';

      if (configuracion.value == null) {
        error.value = 'No hay configuración para guardar';
        return;
      }

      // Crear nuevo objeto con valores actualizados
      ConfiguracionModel configActualizada = configuracion.value!.copyWith(
        porcentajeGananciasMin: porcentajeGananciasMin.value,
        porcentajeGananciasDefault: porcentajeGananciasDefault.value,
        precioDisenioEstandar: precioDisenioEstandar.value,
        precioDisenioPersonalizado: precioDisenioPersonalizado.value,
        costoEnvioNormal: costoEnvioNormal.value,
        costoEnvioExpress: costoEnvioExpress.value,
        aplicarDesperdicioDefault: aplicarDesperdicioDefault.value,
        porcentajeDesperdicio: porcentajeDesperdicio.value,
        precioCuartoHoja: precioCuartoHoja.value,
        precioMediaHoja: precioMediaHoja.value,
        precioRedesSociales: precioRedesSociales.value,
        precioMayorista: precioMayorista.value,
        cantidadMayorista: cantidadMayorista.value,
      );

      await _configProvider.actualizarConfiguracion(configActualizada);
      configuracion.value = configActualizada;

      Get.snackbar(
        'Éxito',
        'Configuración guardada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = 'Error al guardar configuración: $e';
      print(error.value);
      Get.snackbar('Error', error.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      cargando.value = false;
    }
  }

  // Guardar costo fijo
  Future<void> guardarCostoFijo(CostoFijoModel costo) async {
    try {
      cargando.value = true;
      error.value = '';

      if (costo.id.isEmpty) {
        // Crear nuevo costo fijo
        await _configProvider.crearCostoFijo(costo);
      } else {
        // Actualizar costo fijo existente
        await _configProvider.actualizarCostoFijo(costo);
      }

      // Recargar costos fijos
      await cargarCostosFijos();

      Get.snackbar(
        'Éxito',
        'Costo fijo guardado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = 'Error al guardar costo fijo: $e';
      print(error.value);
      Get.snackbar('Error', error.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      cargando.value = false;
    }
  }

  // Eliminar costo fijo
  Future<void> eliminarCostoFijo(String id) async {
    try {
      cargando.value = true;
      error.value = '';

      await _configProvider.eliminarCostoFijo(id);

      // Recargar costos fijos
      await cargarCostosFijos();

      Get.snackbar(
        'Éxito',
        'Costo fijo eliminado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = 'Error al eliminar costo fijo: $e';
      print(error.value);
      Get.snackbar('Error', error.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      cargando.value = false;
    }
  }

  // Activar/desactivar costo fijo
  Future<void> toggleCostoFijo(String id, bool activo) async {
    try {
      await _configProvider.toggleCostoFijo(id, activo);

      // Recargar costos fijos
      await cargarCostosFijos();
    } catch (e) {
      error.value = 'Error al cambiar estado: $e';
      print(error.value);
      Get.snackbar('Error', error.value, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
