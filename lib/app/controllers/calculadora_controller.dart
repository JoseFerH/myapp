import 'package:get/get.dart';
import '../data/models/hoja_model.dart';
import '../data/models/laminado_model.dart';
import '../data/models/item_venta_model.dart';
import '../data/models/cliente_model.dart';
import '../data/models/proyecto_model.dart';
import '../data/services/calculadora_service.dart';
import '../data/services/cliente_service.dart';
import '../data/services/carrito_service.dart';

class CalculadoraController extends GetxController {
  final CalculadoraService _calculadoraService = Get.find<CalculadoraService>();
  final ClienteService _clienteService = Get.find<ClienteService>();
  final CarritoService _carritoService = Get.find<CarritoService>();

  // Getters para acceder a las propiedades del servicio
  RxList<HojaModel> get hojas => _calculadoraService.hojas;
  RxList<LaminadoModel> get laminados => _calculadoraService.laminados;
  RxList<HojaModel> get hojasSeleccionadas =>
      _calculadoraService.hojasSeleccionadas;
  RxList<LaminadoModel> get laminadosSeleccionados =>
      _calculadoraService.laminadosSeleccionados;
  RxSet<String> get hojasSeleccionadasIds =>
      _calculadoraService.hojasSeleccionadasIds;
  RxSet<String> get laminadosSeleccionadosIds =>
      _calculadoraService.laminadosSeleccionadosIds;
  Rx<TamanoSticker> get tamanoSeleccionado =>
      _calculadoraService.tamanoSeleccionado;
  Rx<TipoDiseno> get tipoDiseno => _calculadoraService.tipoDiseno;
  RxDouble get precioDiseno => _calculadoraService.precioDiseno;
  RxBool get aplicarDesperdicio => _calculadoraService.aplicarDesperdicio;
  RxInt get cantidad => _calculadoraService.cantidad;
  RxDouble get costoMateriales => _calculadoraService.costoMateriales;
  RxDouble get costosFijos => _calculadoraService.costosFijos;
  RxDouble get subtotal => _calculadoraService.subtotal;
  RxDouble get ganancia => _calculadoraService.ganancia;
  RxDouble get precioUnitario => _calculadoraService.precioUnitario;
  RxDouble get precioTotal => _calculadoraService.precioTotal;
  RxList<ProyectoModel> get proyectos => _calculadoraService.proyectos;
  Rx<ProyectoModel?> get proyectoSeleccionado =>
      _calculadoraService.proyectoSeleccionado;
  RxBool get cargando => _calculadoraService.cargando;
  RxString get error => _calculadoraService.error;

  // Clientes para selector
  RxList<ClienteModel> clientes = <ClienteModel>[].obs;
  RxList<ClienteModel> clientesFiltrados = <ClienteModel>[].obs;
  Rx<ClienteModel?> clienteSeleccionado = Rx<ClienteModel?>(null);

  @override
  void onInit() {
    super.onInit();
    cargarDatos();
  }

  // Cargar datos iniciales
  Future<void> cargarDatos() async {
    try {
      cargando.value = true;

      // Cargar clientes
      await cargarClientes();

      // Cargar materiales y configuración del servicio
      await _calculadoraService.actualizarDatos();

      update(); // Actualizar UI
    } catch (e) {
      error.value = 'Error al cargar datos: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Verificar si hay materiales disponibles para seleccionar
  bool get hayHojasDisponiblesParaSeleccionar =>
      _calculadoraService.hayHojasDisponiblesParaSeleccionar;

  bool get hayLaminadosDisponiblesParaSeleccionar =>
      _calculadoraService.hayLaminadosDisponiblesParaSeleccionar;

  // Agregar una hoja a la selección
  void agregarHoja(HojaModel hoja) {
    _calculadoraService.agregarHoja(hoja);
    update();
  }

  // Agregar un laminado a la selección
  void agregarLaminado(LaminadoModel laminado) {
    _calculadoraService.agregarLaminado(laminado);
    update();
  }

  // Quitar una hoja de la selección
  void quitarHoja(int index) {
    _calculadoraService.quitarHoja(index);
    update();
  }

  // Quitar un laminado de la selección
  void quitarLaminado(int index) {
    _calculadoraService.quitarLaminado(index);
    update();
  }

  // Seleccionar tamaño
  void seleccionarTamano(TamanoSticker tamano) {
    _calculadoraService.tamanoSeleccionado.value = tamano;
    _calculadoraService.calcularPrecio();
    update();
  }

  // Seleccionar tipo de diseño
  void seleccionarTipoDiseno(TipoDiseno tipo) {
    _calculadoraService.tipoDiseno.value = tipo;
    if (tipo == TipoDiseno.estandar) {
      _calculadoraService.precioDiseno.value =
          _calculadoraService.configuracion.precioDisenioEstandar;
    }
    _calculadoraService.calcularPrecio();
    update();
  }

  // Cambiar precio de diseño
  void cambiarPrecioDiseno(double precio) {
    _calculadoraService.precioDiseno.value = precio;
    _calculadoraService.calcularPrecio();
    update();
  }

  // Cambiar cantidad
  void cambiarCantidad(int nuevaCantidad) {
    _calculadoraService.cantidad.value = nuevaCantidad < 1 ? 1 : nuevaCantidad;
    _calculadoraService.calcularPrecio();
    update();
  }

  // Toggle para aplicar desperdicio
  void toggleDesperdicio(bool valor) {
    _calculadoraService.aplicarDesperdicio.value = valor;
    _calculadoraService.calcularPrecio();
    update();
  }

  // Seleccionar proyecto
  void seleccionarProyecto(ProyectoModel proyecto) {
    _calculadoraService.proyectoSeleccionado.value = proyecto;
    update();
  }

  // Calcular costo de tinta según el tamaño
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

  // Resetear los valores del cálculo
  void resetear() {
    _calculadoraService.resetear();
    update();
  }

  // Recargar materiales
  Future<void> recargarMateriales() async {
    await _calculadoraService.cargarMateriales();
    update();
  }

  // Actualizar todos los datos
  Future<void> refrescarDatos() async {
    await _calculadoraService.actualizarDatos();
    update();
    return Future.value();
  }

  // Agregar al carrito
  void agregarAlCarrito() {
    try {
      if (hojasSeleccionadas.isEmpty || laminadosSeleccionados.isEmpty) {
        error.value = 'Seleccione al menos un material de cada tipo';
        return;
      }

      final itemVenta = _calculadoraService.crearItemVenta();
      _carritoService.agregarItem(itemVenta);

      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Producto agregado al carrito',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Resetear para nueva calculación
      resetear();
    } catch (e) {
      error.value = 'Error al agregar al carrito: $e';
      print(error.value);
      Get.snackbar('Error', error.value, snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Cargar clientes
  Future<void> cargarClientes() async {
    try {
      List<ClienteModel> listaClientes =
          await _clienteService.obtenerClientes();
      clientes.assignAll(listaClientes);
      clientesFiltrados.assignAll(listaClientes);
    } catch (e) {
      print('Error al cargar clientes: $e');
    }
  }

  // Filtrar clientes
  void filtrarClientes(String query) {
    if (query.isEmpty) {
      clientesFiltrados.assignAll(clientes);
    } else {
      clientesFiltrados.assignAll(
        clientes.where(
          (cliente) =>
              cliente.nombre.toLowerCase().contains(query.toLowerCase()) ||
              cliente.zona.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  // Seleccionar cliente
  void seleccionarCliente(ClienteModel cliente) {
    clienteSeleccionado.value = cliente;
  }
}
