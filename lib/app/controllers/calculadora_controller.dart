import 'package:get/get.dart';
import '../data/services/calculadora_service.dart';
import '../data/services/carrito_service.dart';
import '../data/models/hoja_model.dart';
import '../data/models/laminado_model.dart';
import '../data/models/item_venta_model.dart';

class CalculadoraController extends GetxController {
  // Servicios
  final CalculadoraService _calculadoraService = Get.find<CalculadoraService>();
  final CarritoService _carritoService = Get.find<CarritoService>();

  // Variables reactivas para el estado
  final cargando = false.obs;
  final error = ''.obs;

  // Variables reactivas para los materiales
  final hojaSeleccionada = Rx<HojaModel?>(null);
  final laminadoSeleccionada = Rx<LaminadoModel?>(null);
  final tamanoSeleccionado = TamanoSticker.cuarto.obs;
  final tipoDiseno = TipoDiseno.estandar.obs;
  final precioDiseno = 0.0.obs;
  final aplicarDesperdicio = true.obs;
  final cantidad = 1.obs;

  // Variables reactivas para mostrar resultados
  final costoMateriales = 0.0.obs;
  final costosFijos = 0.0.obs;
  final subtotal = 0.0.obs;
  final ganancia = 0.0.obs;
  final precioUnitario = 0.0.obs;
  final precioTotal = 0.0.obs;

  // Listas de materiales
  final hojas = <HojaModel>[].obs;
  final laminados = <LaminadoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("CalculadoraController: onInit iniciado");
    _inicializar();
  }

  // Método de inicialización
  void _inicializar() async {
    try {
      cargando.value = true;
      error.value = '';

      print("CalculadoraController: Obteniendo servicios");
      // Asegurarse de que los servicios están inicializados
      if (!_calculadoraService.hojas.isNotEmpty) {
        print("CalculadoraController: Materiales no cargados, recargando");
        await _calculadoraService.cargarMateriales();
      }

      // Actualizar listas de materiales
      print("CalculadoraController: Actualizando listas de materiales");
      hojas.assignAll(_calculadoraService.hojas);
      laminados.assignAll(_calculadoraService.laminados);

      // Actualizar selecciones si las listas no están vacías
      print("CalculadoraController: Verificando si hay materiales disponibles");
      print("CalculadoraController: Hojas disponibles: ${hojas.length}");
      print(
        "CalculadoraController: Laminados disponibles: ${laminados.length}",
      );

      if (hojas.isNotEmpty) {
        hojaSeleccionada.value = hojas.first;
      }

      if (laminados.isNotEmpty) {
        laminadoSeleccionada.value = laminados.first;
      }

      // Actualizar configuración desde servicio
      aplicarDesperdicio.value = _calculadoraService.aplicarDesperdicio.value;

      // Calcular precios iniciales
      calcularPrecio();
    } catch (e) {
      error.value = 'Error al inicializar calculadora: $e';
      print("CalculadoraController ERROR: ${error.value}");
    } finally {
      cargando.value = false;
      print("CalculadoraController: Inicialización completada");
    }
  }

  // Método para calcular precio
  void calcularPrecio() {
    print("CalculadoraController: Calculando precio");
    try {
      if (hojaSeleccionada.value == null ||
          laminadoSeleccionada.value == null) {
        print("CalculadoraController: Materiales no seleccionados");
        return;
      }

      // Actualizar servicio con las selecciones actuales
      _calculadoraService.hojaSeleccionada.value = hojaSeleccionada.value;
      _calculadoraService.laminadoSeleccionada.value =
          laminadoSeleccionada.value;
      _calculadoraService.tamanoSeleccionado.value = tamanoSeleccionado.value;
      _calculadoraService.tipoDiseno.value = tipoDiseno.value;
      _calculadoraService.precioDiseno.value = precioDiseno.value;
      _calculadoraService.aplicarDesperdicio.value = aplicarDesperdicio.value;
      _calculadoraService.cantidad.value = cantidad.value;

      // Calcular precio en el servicio
      _calculadoraService.calcularPrecio();

      // Actualizar resultados desde el servicio
      costoMateriales.value = _calculadoraService.costoMateriales.value;
      costosFijos.value = _calculadoraService.costosFijos.value;
      subtotal.value = _calculadoraService.subtotal.value;
      ganancia.value = _calculadoraService.ganancia.value;
      precioUnitario.value = _calculadoraService.precioUnitario.value;
      precioTotal.value = _calculadoraService.precioTotal.value;

      print(
        "CalculadoraController: Precio calculado - Unitario: ${precioUnitario.value}, Total: ${precioTotal.value}",
      );

      // Forzar una actualización de la UI
      update();
    } catch (e) {
      error.value = 'Error en el cálculo: $e';
      print("CalculadoraController ERROR: ${error.value}");
    }
  }

  // Métodos para actualizar selecciones
  void seleccionarHoja(HojaModel hoja) {
    print("CalculadoraController: Seleccionando hoja: ${hoja.nombre}");
    hojaSeleccionada.value = hoja;
    calcularPrecio();
  }

  void seleccionarLaminado(LaminadoModel laminado) {
    print("CalculadoraController: Seleccionando laminado: ${laminado.nombre}");
    laminadoSeleccionada.value = laminado;
    calcularPrecio();
  }

  void seleccionarTamano(TamanoSticker tamano) {
    print("CalculadoraController: Seleccionando tamaño: $tamano");
    tamanoSeleccionado.value = tamano;
    calcularPrecio();
  }

  void seleccionarTipoDiseno(TipoDiseno tipo) {
    print("CalculadoraController: Seleccionando tipo diseño: $tipo");
    tipoDiseno.value = tipo;
    calcularPrecio();
  }

  void cambiarPrecioDiseno(double precio) {
    print("CalculadoraController: Cambiando precio diseño: $precio");
    precioDiseno.value = precio;
    calcularPrecio();
  }

  void cambiarCantidad(int nuevaCantidad) {
    print("CalculadoraController: Cambiando cantidad: $nuevaCantidad");
    if (nuevaCantidad < 1) nuevaCantidad = 1;
    cantidad.value = nuevaCantidad;
    calcularPrecio();
  }

  void toggleDesperdicio(bool valor) {
    print("CalculadoraController: Toggle desperdicio: $valor");
    aplicarDesperdicio.value = valor;
    calcularPrecio();
  }

  void resetear() {
    print("CalculadoraController: Reseteando calculadora");
    _calculadoraService.resetear();

    // Actualizar valores locales desde el servicio
    tamanoSeleccionado.value = _calculadoraService.tamanoSeleccionado.value;
    tipoDiseno.value = _calculadoraService.tipoDiseno.value;
    precioDiseno.value = _calculadoraService.precioDiseno.value;
    aplicarDesperdicio.value = _calculadoraService.aplicarDesperdicio.value;
    cantidad.value = _calculadoraService.cantidad.value;

    // Recalcular
    calcularPrecio();
  }
  // Método para calcular costo de tinta

  // Método para calcular costo de tinta
  double calcularCostoTinta() {
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

  void agregarAlCarrito() {
    try {
      print("CalculadoraController: Agregando al carrito");
      // Crear item de venta desde el servicio
      ItemVentaModel item = _calculadoraService.crearItemVenta();

      // Agregar al carrito
      _carritoService.agregarItem(item);

      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Producto agregado al carrito',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = 'Error al agregar al carrito: $e';
      print("CalculadoraController ERROR: ${error.value}");

      // Mostrar mensaje de error
      Get.snackbar('Error', error.value, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
