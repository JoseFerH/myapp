import 'package:get/get.dart';
import '../data/services/calculadora_service.dart';
import '../data/services/carrito_service.dart';
import '../data/models/hoja_model.dart';
import '../data/models/laminado_model.dart';
import '../data/models/item_venta_model.dart';
import '../data/services/calculadora_service.dart';
import '../data/services/carrito_service.dart';
import '../data/services/cliente_service.dart';
import '../data/models/cliente_model.dart';

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

  final CalculadoraService calculadoraService = Get.find<CalculadoraService>();
  final CarritoService carritoService = Get.find<CarritoService>();

  // Propiedades para manejar la selección de cliente
  final Rx<ClienteModel?> clienteSeleccionado = Rx<ClienteModel?>(null);
  final RxList<ClienteModel> clientes = <ClienteModel>[].obs;
  final RxList<ClienteModel> clientesFiltrados = <ClienteModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargarClientes();
    print("CalculadoraController: onInit iniciado");
    _inicializar();
  }

  // Añade este método al CalculadoraController si no existe o está comentado
  Future<void> refrescarDatos() async {
    try {
      cargando.value = true;
      error.value = '';

      // Obtener el servicio de calculadora
      final calculadoraService = Get.find<CalculadoraService>();

      // Actualizar datos en el servicio
      await calculadoraService.actualizarDatos();

      // Actualizar valores en el controlador
      hojaSeleccionada.value = calculadoraService.hojaSeleccionada.value;
      laminadoSeleccionada.value =
          calculadoraService.laminadoSeleccionada.value;
      tamanoSeleccionado.value = calculadoraService.tamanoSeleccionado.value;
      tipoDiseno.value = calculadoraService.tipoDiseno.value;
      precioDiseno.value = calculadoraService.precioDiseno.value;
      aplicarDesperdicio.value = calculadoraService.aplicarDesperdicio.value;
      cantidad.value = calculadoraService.cantidad.value;

      // Recalcular precios
      calcularPrecio();

      update(); // Actualizar la UI

      return Future.value();
    } catch (e) {
      error.value = 'Error al actualizar datos: $e';
      print(error.value);
      return Future.error(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Añadir estos métodos nuevos
  Future<void> cargarClientes() async {
    try {
      // Usar el servicio de clientes para cargar la lista
      final clienteService = Get.find<ClienteService>();
      await clienteService.cargarClientes();
      clientes.assignAll(clienteService.clientes);
      clientesFiltrados.assignAll(clientes);

      // Verificar si hay un cliente seleccionado en el carrito
      final carritoService = Get.find<CarritoService>();
      if (carritoService.clienteSeleccionado.value != null &&
          clienteSeleccionado.value == null) {
        clienteSeleccionado.value = carritoService.clienteSeleccionado.value;
      }
    } catch (e) {
      print('Error al cargar clientes: $e');
    }
  }

  void seleccionarCliente(ClienteModel cliente) {
    clienteSeleccionado.value = cliente;

    // Sincronizar con el carrito
    final carritoService = Get.find<CarritoService>();
    carritoService.seleccionarCliente(cliente);
  }

  void filtrarClientes(String query) {
    if (query.isEmpty) {
      clientesFiltrados.assignAll(clientes);
    } else {
      clientesFiltrados.assignAll(
        clientes
            .where(
              (cliente) =>
                  cliente.nombre.toLowerCase().contains(query.toLowerCase()) ||
                  cliente.zona.toLowerCase().contains(query.toLowerCase()) ||
                  cliente.tipoCliente.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList(),
      );
    }
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
    if (hojaSeleccionada.value == null || laminadoSeleccionada.value == null) {
      Get.snackbar(
        'Error',
        'Seleccione los materiales',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (clienteSeleccionado.value == null) {
      Get.snackbar(
        'Error',
        'Seleccione un cliente primero',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Crear ítem de venta desde los datos actuales
      ItemVentaModel item = calculadoraService.crearItemVenta();

      // Agregar al carrito
      carritoService.agregarItem(item);

      // Ya no es necesario seleccionar cliente en el carrito porque
      // ya lo hemos sincronizado antes

      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Producto agregado al carrito',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Resetear calculadora para nuevo cálculo
      resetear();

      // Navegar al carrito (opcional, podemos mantenerlo o quitarlo)
      // Get.find<HomeController>().changeIndex(3);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
