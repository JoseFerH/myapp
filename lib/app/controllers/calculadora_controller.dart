import 'package:get/get.dart';
import '../data/models/hoja_model.dart';
import '../data/models/laminado_model.dart';
import '../data/models/item_venta_model.dart';
import '../data/services/calculadora_service.dart';
import '../data/services/carrito_service.dart';

class CalculadoraController extends GetxController {
  // Servicios con manejo de errores
  CalculadoraService get _calculadoraService {
    try {
      return Get.find<CalculadoraService>();
    } catch (e) {
      // Si el servicio aún no está registrado, lo registramos
      final service = CalculadoraService();
      Get.put(service, permanent: true);
      service.init();
      return service;
    }
  }

  CarritoService get _carritoService {
    try {
      return Get.find<CarritoService>();
    } catch (e) {
      // Si el servicio aún no está registrado, lo registramos
      final service = CarritoService();
      Get.put(service, permanent: true);
      service.init();
      return service;
    }
  }

  // Variables reactivas de UI
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;

  // Getters para acceder a las variables del servicio
  RxList<HojaModel> get hojas => _calculadoraService.hojas;
  RxList<LaminadoModel> get laminados => _calculadoraService.laminados;

  Rx<HojaModel?> get hojaSeleccionada => _calculadoraService.hojaSeleccionada;
  Rx<LaminadoModel?> get laminadoSeleccionada =>
      _calculadoraService.laminadoSeleccionada;
  Rx<TamanoSticker> get tamanoSeleccionado =>
      _calculadoraService.tamanoSeleccionado;
  Rx<TipoDiseno> get tipoDiseno => _calculadoraService.tipoDiseno;
  RxDouble get precioDiseno => _calculadoraService.precioDiseno;
  RxBool get aplicarDesperdicio => _calculadoraService.aplicarDesperdicio;
  RxInt get cantidad => _calculadoraService.cantidad;

  // Getters para resultados del cálculo
  RxDouble get costoMateriales => _calculadoraService.costoMateriales;
  RxDouble get costosFijos => _calculadoraService.costosFijos;
  RxDouble get subtotal => _calculadoraService.subtotal;
  RxDouble get ganancia => _calculadoraService.ganancia;
  RxDouble get precioUnitario => _calculadoraService.precioUnitario;
  RxDouble get precioTotal => _calculadoraService.precioTotal;

  @override
  void onInit() async {
    super.onInit();
    cargando.value = true;
    try {
      // Asegurar que el servicio esté inicializado correctamente
      Future.delayed(Duration.zero, () {
        try {
          // Realizar cálculo inicial después de la inicialización
          _calculadoraService.calcularPrecio();
        } catch (e) {
          error.value = 'Error al calcular precio: $e';
          print(error.value);
        } finally {
          cargando.value = false;
        }
      });
    } catch (e) {
      error.value = 'Error al inicializar: $e';
      print(error.value);
      cargando.value = false;
    }
  }

  // Método para cambiar la hoja seleccionada
  void seleccionarHoja(HojaModel hoja) {
    _calculadoraService.seleccionarHoja(hoja);
  }

  // Método para cambiar el laminado seleccionado
  void seleccionarLaminado(LaminadoModel laminado) {
    _calculadoraService.seleccionarLaminado(laminado);
  }

  // Método para cambiar el tamaño del sticker
  void seleccionarTamano(TamanoSticker tamano) {
    _calculadoraService.seleccionarTamano(tamano);
  }

  // Método para cambiar el tipo de diseño
  void seleccionarTipoDiseno(TipoDiseno tipo) {
    _calculadoraService.seleccionarTipoDiseno(tipo);
  }

  // Método para cambiar el precio de diseño personalizado
  void cambiarPrecioDiseno(double precio) {
    _calculadoraService.cambiarPrecioDiseno(precio);
  }

  // Método para cambiar la cantidad
  void cambiarCantidad(int nuevaCantidad) {
    _calculadoraService.cambiarCantidad(nuevaCantidad);
  }

  // Método para toggle desperdicio
  void toggleDesperdicio(bool valor) {
    _calculadoraService.toggleDesperdicio(valor);
  }

  // Método para resetear los valores
  void resetear() {
    _calculadoraService.resetear();
  }

  // Método para agregar al carrito
  Future<void> agregarAlCarrito() async {
    try {
      error.value = '';

      // Crear item de venta
      ItemVentaModel item = _calculadoraService.crearItemVenta();

      // Agregar al carrito
      _carritoService.agregarItem(item);

      // Resetear los valores para nueva calculación
      resetear();

      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Producto agregado al carrito',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = 'Error al agregar al carrito: $e';
      print(error.value);
      Get.snackbar('Error', error.value, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
