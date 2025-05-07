// lib/app/controllers/carrito_controller.dart

import 'dart:io';
import 'package:get/get.dart';
import '../data/models/cliente_model.dart';
import '../data/models/item_venta_model.dart';
import '../data/models/venta_model.dart';
import '../data/services/carrito_service.dart';
import '../data/services/cliente_service.dart';
import '../data/services/pdf_service.dart';
import '../data/services/venta_service.dart'; // Añadido para resolver error de referencia

class CarritoController extends GetxController {
  // Servicios
  final CarritoService _carritoService = Get.find<CarritoService>();
  final ClienteService _clienteService = Get.find<ClienteService>();
  final PDFService _pdfService = Get.find<PDFService>();
  
  // Variables reactivas de UI
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  final RxList<ClienteModel> clientes = <ClienteModel>[].obs;
  final RxString notasCotizacion = ''.obs;
  
  // Getters para acceder a las variables del servicio
  RxList<ItemVentaModel> get items => _carritoService.items;
  Rx<ClienteModel?> get clienteSeleccionado => _carritoService.clienteSeleccionado;
  Rx<TipoEnvio> get tipoEnvio => _carritoService.tipoEnvio;
  RxDouble get costoEnvioPersonalizado => _carritoService.costoEnvioPersonalizado;
  RxDouble get subtotal => _carritoService.subtotal;
  RxDouble get costoEnvio => _carritoService.costoEnvio;
  RxDouble get total => _carritoService.total;
  
  @override
  void onInit() async {
    super.onInit();
    cargando.value = true;
    try {
      // Inicializar servicio si no está inicializado
      await _carritoService.init();
      
      // Cargar lista de clientes
      await cargarClientes();
    } catch (e) {
      error.value = 'Error al inicializar: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Cargar lista de clientes - CORREGIDO
  Future<void> cargarClientes() async {
    try {
      cargando.value = true;
      error.value = '';
      
      // Primero llamamos al método que actualiza la lista interna en el servicio
      await _clienteService.cargarClientes();
      
      // Luego accedemos a la lista actualizada desde el servicio
      clientes.assignAll(_clienteService.clientes);
    } catch (e) {
      error.value = 'Error al cargar clientes: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Métodos para gestión del carrito
  void eliminarItem(int index) {
    _carritoService.eliminarItem(index);
  }
  
  void seleccionarCliente(ClienteModel cliente) {
    _carritoService.seleccionarCliente(cliente);
  }
  
  void seleccionarTipoEnvio(TipoEnvio tipo) {
    _carritoService.seleccionarTipoEnvio(tipo);
  }
  
  void setCostoEnvioPersonalizado(double costo) {
    _carritoService.setCostoEnvioPersonalizado(costo);
  }
  
  void setNotas(String notas) {
    _carritoService.setNotas(notas);
    notasCotizacion.value = notas;
  }
  
  // Generar cotización
Future<void> generarCotizacion() async {
  try {
    cargando.value = true;
    error.value = '';
    
    if (items.isEmpty) {
      error.value = 'El carrito está vacío';
      return;
    }
    
    if (clienteSeleccionado.value == null) {
      error.value = 'Seleccione un cliente';
      return;
    }
    
    // Crear cotización
    String ventaId = await _carritoService.crearCotizacion();
    
    if (ventaId.isEmpty) {
      error.value = 'Error al crear cotización';
      return;
    }
    
    // Generar PDF - CORREGIDO
    VentaModel? venta = await Get.find<VentaService>().cargarVentaPorId(ventaId);
    
    // Verificar que la venta no sea nula
    if (venta == null) {
      error.value = 'Error al cargar la venta';
      return;
    }
    
    File? pdfFile = await _pdfService.generarCotizacion(venta);
    
    if (pdfFile != null) {
      // Compartir PDF
      await _pdfService.compartirPDF(pdfFile);
      
      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Cotización generada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      error.value = 'Error al generar PDF';
    }
  } catch (e) {
    error.value = 'Error al generar cotización: $e';
    print(error.value);
  } finally {
    cargando.value = false;
  }
}
  
  // Crear venta directa
  Future<void> crearVenta() async {
    try {
      cargando.value = true;
      error.value = '';
      
      if (items.isEmpty) {
        error.value = 'El carrito está vacío';
        return;
      }
      
      if (clienteSeleccionado.value == null) {
        error.value = 'Seleccione un cliente';
        return;
      }
      
      // Crear venta directa (completada)
      String ventaId = await _carritoService.crearVenta();
      
      if (ventaId.isEmpty) {
        error.value = 'Error al crear venta';
        return;
      }
      
      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Venta creada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = 'Error al crear venta: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Limpiar carrito
  void limpiarCarrito() {
    _carritoService.limpiarCarrito();
  }
  
  // Verificar si se puede aplicar promoción de redes sociales
  bool verificarPromoRedesSociales() {
    return _carritoService.esPromoRedesSociales();
  }
  
  // Aplicar promoción de redes sociales
  void aplicarPromoRedesSociales() {
    _carritoService.aplicarPromoRedesSociales();
  }
}