import 'package:get/get.dart';
import '../models/material_model.dart';
import '../models/hoja_model.dart';
import '../models/laminado_model.dart';
import '../models/costo_fijo_model.dart';
import '../models/configuracion_model.dart';
import '../models/item_venta_model.dart';
import '../providers/materiales_provider.dart';
import '../providers/configuracion_provider.dart';
import '../models/proyecto_model.dart';
import '../providers/proyectos_provider.dart';

class CalculadoraService extends GetxService {
  final MaterialesProvider _materialesProvider = MaterialesProvider();
  final ConfiguracionProvider _configuracionProvider = ConfiguracionProvider();

  // Rx Variables para el estado
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;

  // Variables para el cálculo
  // Cambiar de Rx<Type?> a RxList<Type>
  final RxList<HojaModel> hojasSeleccionadas = <HojaModel>[].obs;
  final RxList<LaminadoModel> laminadosSeleccionados = <LaminadoModel>[].obs;
  final Rx<TamanoSticker> tamanoSeleccionado = TamanoSticker.cuarto.obs;
  final Rx<TipoDiseno> tipoDiseno = TipoDiseno.estandar.obs;
  final RxDouble precioDiseno = 0.0.obs;
  final RxBool aplicarDesperdicio = true.obs;
  final RxInt cantidad = 1.obs;

  // Resultados del cálculo
  final RxDouble costoMateriales = 0.0.obs;
  final RxDouble costosFijos = 0.0.obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble ganancia = 0.0.obs;
  final RxDouble precioUnitario = 0.0.obs;
  final RxDouble precioTotal = 0.0.obs;
  final ProyectosProvider _proyectosProvider = ProyectosProvider();
  final Rx<ProyectoModel?> proyectoSeleccionado = Rx<ProyectoModel?>(null);
  RxList<ProyectoModel> proyectos = <ProyectoModel>[].obs;

  // Configuración global
  late ConfiguracionModel configuracion;

  // Lista de costos fijos
  RxList<CostoFijoModel> listaCostosFijos = <CostoFijoModel>[].obs;

  // Listas de materiales disponibles
  RxList<HojaModel> hojas = <HojaModel>[].obs;
  RxList<LaminadoModel> laminados = <LaminadoModel>[].obs;

  // Mantener referencia a hojas/laminados ya seleccionados para UI
  final RxSet<String> hojasSeleccionadasIds = <String>{}.obs;
  final RxSet<String> laminadosSeleccionadosIds = <String>{}.obs;

  // Inicializar servicio
  Future<CalculadoraService> init() async {
    try {
      cargando.value = true;
      error.value = '';

      // Cargar configuración global
      configuracion = await _configuracionProvider.obtenerConfiguracion();

      // Cargar costos fijos
      List<CostoFijoModel> costos =
          await _configuracionProvider.obtenerCostosFijos();
      listaCostosFijos.assignAll(costos);

      // Cargar materiales disponibles
      await cargarMateriales();
      await cargarProyectos();

      // Inicializar valores por defecto
      aplicarDesperdicio.value = configuracion.aplicarDesperdicioDefault;

      return this;
    } catch (e) {
      error.value = 'Error al inicializar: $e';
      print(error.value);
      return this;
    } finally {
      cargando.value = false;
    }
  }

  // Cargar proyectos
  Future<void> cargarProyectos() async {
    try {
      List<ProyectoModel> listaProyectos =
          await _proyectosProvider.obtenerProyectos();
      proyectos.assignAll(listaProyectos.where((proyecto) => proyecto.activo));

      // Seleccionar el primer proyecto por defecto
      if (proyectos.isNotEmpty && proyectoSeleccionado.value == null) {
        proyectoSeleccionado.value = proyectos.first;
      }
    } catch (e) {
      error.value = 'Error al cargar proyectos: $e';
      print(error.value);
    }
  }

  Future<void> cargarMateriales() async {
    try {
      // Cargar hojas
      print("CalculadoraService: Cargando hojas");
      List<HojaModel> listaHojas = await _materialesProvider.obtenerHojas();
      print("CalculadoraService: Se encontraron ${listaHojas.length} hojas");

      hojas.assignAll(listaHojas.where((hoja) => hoja.cantidadDisponible > 0));
      print("CalculadoraService: ${hojas.length} hojas con stock disponible");

      // Cargar laminados
      print("CalculadoraService: Cargando laminados");
      List<LaminadoModel> listaLaminados =
          await _materialesProvider.obtenerLaminados();
      print(
        "CalculadoraService: Se encontraron ${listaLaminados.length} laminados",
      );

      laminados.assignAll(
        listaLaminados.where((laminado) => laminado.cantidadDisponible > 0),
      );
      print(
        "CalculadoraService: ${laminados.length} laminados con stock disponible",
      );

      // Limpiar selecciones actuales
      hojasSeleccionadas.clear();
      laminadosSeleccionados.clear();
      hojasSeleccionadasIds.clear();
      laminadosSeleccionadosIds.clear();
    } catch (e) {
      error.value = 'Error al cargar materiales: $e';
      print("CalculadoraService ERROR: ${error.value}");
    }
  }

  // Verificar si hay hojas disponibles para seleccionar que no han sido seleccionadas aún
  bool get hayHojasDisponiblesParaSeleccionar {
    return hojas.any((h) => !hojasSeleccionadasIds.contains(h.id));
  }

  // Verificar si hay laminados disponibles para seleccionar que no han sido seleccionados aún
  bool get hayLaminadosDisponiblesParaSeleccionar {
    return laminados.any((l) => !laminadosSeleccionadosIds.contains(l.id));
  }

  // Agregar una hoja a la selección
  void agregarHoja(HojaModel hoja) {
    if (!hojasSeleccionadasIds.contains(hoja.id)) {
      hojasSeleccionadas.add(hoja);
      hojasSeleccionadasIds.add(hoja.id);
      calcularPrecio();
    }
  }

  // Agregar un laminado a la selección
  void agregarLaminado(LaminadoModel laminado) {
    if (!laminadosSeleccionadosIds.contains(laminado.id)) {
      laminadosSeleccionados.add(laminado);
      laminadosSeleccionadosIds.add(laminado.id);
      calcularPrecio();
    }
  }

  // Quitar una hoja de la selección
  void quitarHoja(int index) {
    if (index >= 0 && index < hojasSeleccionadas.length) {
      final hoja = hojasSeleccionadas[index];
      hojasSeleccionadasIds.remove(hoja.id);
      hojasSeleccionadas.removeAt(index);
      calcularPrecio();
    }
  }

  // Quitar un laminado de la selección
  void quitarLaminado(int index) {
    if (index >= 0 && index < laminadosSeleccionados.length) {
      final laminado = laminadosSeleccionados[index];
      laminadosSeleccionadosIds.remove(laminado.id);
      laminadosSeleccionados.removeAt(index);
      calcularPrecio();
    }
  }

  // Calcular precio según las selecciones actuales
  void calcularPrecio() {
    if (hojasSeleccionadas.isEmpty && laminadosSeleccionados.isEmpty) {
      error.value = 'Seleccione al menos un material de cada tipo';
      return;
    }

    try {
      error.value = '';

      // 1. Calcular costo de materiales según el tamaño
      double costoHojas = 0.0;
      for (var hoja in hojasSeleccionadas) {
        costoHojas += _calcularCostoMaterialSegunTamano(hoja.precioUnitario);
      }

      double costoLaminados = 0.0;
      for (var laminado in laminadosSeleccionados) {
        costoLaminados += _calcularCostoMaterialSegunTamano(
          laminado.precioUnitario,
        );
      }

      double costoTinta = _calcularCostoTinta();

      costoMateriales.value = costoHojas + costoLaminados + costoTinta;

      // 2. Sumar costos fijos
      costosFijos.value = _calcularCostosFijos();

      // 3. Aplicar desperdicio si está activado
      double subtotalTemp = costoMateriales.value + costosFijos.value;
      if (aplicarDesperdicio.value) {
        subtotalTemp +=
            subtotalTemp * (configuracion.porcentajeDesperdicio / 100);
      }

      // 4. Añadir costo de diseño
      double costoDiseno = 0.0;
      if (tipoDiseno.value == TipoDiseno.estandar) {
        costoDiseno = configuracion.precioDisenioEstandar;
      } else {
        costoDiseno = precioDiseno.value;
      }

      subtotalTemp += costoDiseno;
      subtotal.value = subtotalTemp;

      // 5. Calcular ganancia
      double porcentajeGanancia = configuracion.porcentajeGananciasDefault;
      ganancia.value = subtotal.value * (porcentajeGanancia / 100);

      // 6. Calcular precio unitario
      precioUnitario.value = subtotal.value + ganancia.value;

      // 7. Aplicar reglas especiales según cantidad y tamaño
      _aplicarReglasEspeciales();

      // 8. Calcular precio total
      precioTotal.value = precioUnitario.value * cantidad.value;
    } catch (e) {
      error.value = 'Error en el cálculo: $e';
      print(error.value);
    }
  }

  // Resto de métodos como antes, adaptados para múltiples materiales
  // ...

  // Calcular costo de material según tamaño seleccionado
  double _calcularCostoMaterialSegunTamano(double precioBase) {
    switch (tamanoSeleccionado.value) {
      case TamanoSticker.cuarto:
        return precioBase / 4;
      case TamanoSticker.medio:
        return precioBase / 2;
      case TamanoSticker.tresQuartos:
        return precioBase * 0.75;
      case TamanoSticker.completo:
        return precioBase;
      default:
        return precioBase / 4;
    }
  }

  // Calcular costo de tinta
  double _calcularCostoTinta() {
    // Implementación existente
    double costoCuarto = 2.0;

    switch (tamanoSeleccionado.value) {
      case TamanoSticker.cuarto:
        return costoCuarto;
      case TamanoSticker.medio:
        return costoCuarto * 2;
      case TamanoSticker.tresQuartos:
        return costoCuarto * 3;
      case TamanoSticker.completo:
        return costoCuarto * 4;
      default:
        return costoCuarto;
    }
  }

  // Calcular costos fijos totales
  double _calcularCostosFijos() {
    double total = 0.0;

    // Sumar todos los costos fijos activos
    for (var costo in listaCostosFijos) {
      if (costo.activo) {
        total += costo.valor;
      }
    }

    return total;
  }

  // Aplicar reglas especiales de precios
  void _aplicarReglasEspeciales() {
    // Implementación de reglas de precios existente
    if (tamanoSeleccionado.value == TamanoSticker.cuarto &&
        cantidad.value >= configuracion.cantidadMayorista) {
      precioUnitario.value = configuracion.precioMayorista;
    }
  }

  // Crear un ItemVentaModel con los datos actuales
  ItemVentaModel crearItemVenta() {
    // Calcular el precio actual
    calcularPrecio();

    // Valores por defecto para cuando no hay materiales seleccionados
    String hojaId = "";
    String nombreHoja = "Sin hoja";
    String laminadoId = "";
    String nombreLaminado = "Sin laminado";

    // Si hay hojas seleccionadas, obtener los datos
    if (hojasSeleccionadas.isNotEmpty) {
      hojaId = hojasSeleccionadas.first.id;
      nombreHoja = hojasSeleccionadas.map((h) => h.nombre).join(", ");
    }

    // Si hay laminados seleccionados, obtener los datos
    if (laminadosSeleccionados.isNotEmpty) {
      laminadoId = laminadosSeleccionados.first.id;
      nombreLaminado = laminadosSeleccionados.map((l) => l.nombre).join(", ");
    }

    return ItemVentaModel(
      hojaId: hojaId,
      nombreHoja: nombreHoja,
      laminadoId: laminadoId,
      nombreLaminado: nombreLaminado,
      tamano: tamanoSeleccionado.value,
      tipoDiseno: tipoDiseno.value,
      precioDiseno:
          tipoDiseno.value == TipoDiseno.estandar
              ? configuracion.precioDisenioEstandar
              : precioDiseno.value,
      aplicarDesperdicio: aplicarDesperdicio.value,
      cantidad: cantidad.value,
      precioUnitario: precioUnitario.value,
      precioTotal: precioTotal.value,
      proyectoId: proyectoSeleccionado.value?.id ?? '',
      nombreProyecto: proyectoSeleccionado.value?.nombre ?? '',
    );
  }

  // Resetear los valores del cálculo
  void resetear() {
    tipoDiseno.value = TipoDiseno.estandar;
    precioDiseno.value = 0.0;
    aplicarDesperdicio.value = configuracion.aplicarDesperdicioDefault;
    cantidad.value = 1;
    tamanoSeleccionado.value = TamanoSticker.cuarto;

    // Limpiar todas las selecciones de materiales
    hojasSeleccionadas.clear();
    laminadosSeleccionados.clear();
    hojasSeleccionadasIds.clear();
    laminadosSeleccionadosIds.clear();

    // Recalcular con los nuevos valores
    // No llamamos a calcularPrecio aquí porque no hay materiales seleccionados
  }

  // Método para actualizar todos los datos
  Future<void> actualizarDatos() async {
    try {
      cargando.value = true;
      error.value = '';

      // Recargar materiales y configuración
      await recargarConfiguracion();
      await cargarMateriales();

      // Recalcular con los datos actualizados (solo si hay materiales seleccionados)
      if (hojasSeleccionadas.isNotEmpty && laminadosSeleccionados.isNotEmpty) {
        calcularPrecio();
      }
    } catch (e) {
      error.value = 'Error al actualizar datos: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Recargar la configuración desde Firebase
  Future<void> recargarConfiguracion() async {
    try {
      // Recargar configuración global
      configuracion = await _configuracionProvider.obtenerConfiguracion();

      // Recargar costos fijos
      List<CostoFijoModel> costos =
          await _configuracionProvider.obtenerCostosFijos();
      listaCostosFijos.assignAll(costos);

      // Actualizar valor de desperdicio según configuración
      aplicarDesperdicio.value = configuracion.aplicarDesperdicioDefault;

      // Si el tipo de diseño es estándar, actualizar precio según configuración
      if (tipoDiseno.value == TipoDiseno.estandar) {
        precioDiseno.value = configuracion.precioDisenioEstandar;
      }
    } catch (e) {
      error.value = 'Error al recargar configuración: $e';
      print(error.value);
    }
  }
}
