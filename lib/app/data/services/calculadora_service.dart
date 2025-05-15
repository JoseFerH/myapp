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
  final Rx<HojaModel?> hojaSeleccionada = Rx<HojaModel?>(null);
  final Rx<LaminadoModel?> laminadoSeleccionada = Rx<LaminadoModel?>(null);
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

  // Añadir método para cargar proyectos
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

      // Seleccionar el primer material de cada tipo si la lista no está vacía
      if (hojas.isNotEmpty && hojaSeleccionada.value == null) {
        print(
          "CalculadoraService: Seleccionando hoja por defecto: ${hojas.first.nombre}",
        );
        hojaSeleccionada.value = hojas.first;
      }

      if (laminados.isNotEmpty && laminadoSeleccionada.value == null) {
        print(
          "CalculadoraService: Seleccionando laminado por defecto: ${laminados.first.nombre}",
        );
        laminadoSeleccionada.value = laminados.first;
      }
    } catch (e) {
      error.value = 'Error al cargar materiales: $e';
      print("CalculadoraService ERROR: ${error.value}");
    }
  }

  // Calcular precio según las selecciones actuales
  void calcularPrecio() {
    if (hojaSeleccionada.value == null || laminadoSeleccionada.value == null) {
      error.value = 'Seleccione los materiales';
      return;
    }

    try {
      error.value = '';

      // 1. Calcular costo de materiales según el tamaño
      double costoHoja = _calcularCostoMaterialSegunTamano(
        hojaSeleccionada.value!.precioUnitario,
      );
      double costoLaminado = _calcularCostoMaterialSegunTamano(
        laminadoSeleccionada.value!.precioUnitario,
      );
      double costoTinta = _calcularCostoTinta();

      costoMateriales.value = costoHoja + costoLaminado + costoTinta;

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

  // Calcular costo de tinta (simulado según tamaño)
  double _calcularCostoTinta() {
    // Valor base para un cuarto de hoja
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

  void seleccionarProyecto(ProyectoModel proyecto) {
    proyectoSeleccionado.value = proyecto;
    calcularPrecio();
  }

  // Aplicar reglas especiales de precios
  void _aplicarReglasEspeciales() {
    // Eliminar la regla 1 que establecía precios fijos por tamaño
    // Regla 1: ELIMINADA - Ya no aplicamos precios fijos según el tamaño

    // Regla 2: A partir de 100 1/4 de Hoja, cada 1/4 de Hoja costará Q10 Con diseño Incluido
    if (tamanoSeleccionado.value == TamanoSticker.cuarto &&
        cantidad.value >= configuracion.cantidadMayorista) {
      precioUnitario.value = configuracion.precioMayorista;
    }

    // Regla 3: Redes Sociales, 3 por Q90 con envío incluido
    // Esta regla se aplicará en el servicio de carrito ya que involucra envío
  }

  // Crear un ItemVentaModel con los datos actuales
  ItemVentaModel crearItemVenta() {
    if (hojaSeleccionada.value == null || laminadoSeleccionada.value == null) {
      throw Exception('Seleccione los materiales');
    }

    // Calcular el precio actual
    calcularPrecio();

    return ItemVentaModel(
      hojaId: hojaSeleccionada.value!.id,
      nombreHoja: hojaSeleccionada.value!.nombre,
      laminadoId: laminadoSeleccionada.value!.id,
      nombreLaminado: laminadoSeleccionada.value!.nombre,
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

    // No resetear los materiales seleccionados para mayor comodidad
    // hojaSeleccionada.value = hojas.isNotEmpty ? hojas.first : null;
    // laminadoSeleccionada.value = laminados.isNotEmpty ? laminados.first : null;

    // Recalcular con los nuevos valores
    calcularPrecio();
  }

  // Actualizar hoja seleccionada
  void seleccionarHoja(HojaModel hoja) {
    hojaSeleccionada.value = hoja;
    calcularPrecio();
  }

  // Actualizar laminado seleccionado
  void seleccionarLaminado(LaminadoModel laminado) {
    laminadoSeleccionada.value = laminado;
    calcularPrecio();
  }

  // Actualizar tamaño
  void seleccionarTamano(TamanoSticker tamano) {
    tamanoSeleccionado.value = tamano;
    calcularPrecio();
  }

  // Actualizar tipo de diseño
  void seleccionarTipoDiseno(TipoDiseno tipo) {
    tipoDiseno.value = tipo;
    if (tipo == TipoDiseno.estandar) {
      precioDiseno.value = configuracion.precioDisenioEstandar;
    }
    calcularPrecio();
  }

  // Actualizar precio de diseño personalizado
  void cambiarPrecioDiseno(double precio) {
    precioDiseno.value = precio;
    calcularPrecio();
  }

  // Actualizar cantidad
  void cambiarCantidad(int nuevaCantidad) {
    if (nuevaCantidad < 1) nuevaCantidad = 1;
    cantidad.value = nuevaCantidad;
    calcularPrecio();
  }

  // Actualizar aplicar desperdicio
  void toggleDesperdicio(bool valor) {
    aplicarDesperdicio.value = valor;
    calcularPrecio();
  }

  // NUEVOS MÉTODOS PARA SOLUCIONAR EL PROBLEMA

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

      // Recalcular con la nueva configuración
      calcularPrecio();
    } catch (e) {
      error.value = 'Error al recargar configuración: $e';
      print(error.value);
    }
  }

  // Método principal para actualizar todos los datos
  Future<void> actualizarDatos() async {
    try {
      cargando.value = true;
      error.value = '';

      // Recargar materiales y configuración
      await recargarConfiguracion();
      await cargarMateriales();

      // Recalcular con los datos actualizados
      calcularPrecio();
    } catch (e) {
      error.value = 'Error al actualizar datos: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
}
