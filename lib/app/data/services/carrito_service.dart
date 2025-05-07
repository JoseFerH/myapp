import 'package:get/get.dart';
import '../models/venta_model.dart';
import '../models/item_venta_model.dart';
import '../models/cliente_model.dart';
import '../models/configuracion_model.dart';
import '../providers/ventas_provider.dart';
import '../providers/configuracion_provider.dart';
import '../providers/clientes_provider.dart';

class CarritoService extends GetxService {
  final VentasProvider _ventasProvider = VentasProvider();
  final ConfiguracionProvider _configuracionProvider = ConfiguracionProvider();
  final ClientesProvider _clientesProvider = ClientesProvider();
  
  // Rx Variables para el estado
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  
  // Carrito actual
  final RxList<ItemVentaModel> items = <ItemVentaModel>[].obs;
  final Rx<ClienteModel?> clienteSeleccionado = Rx<ClienteModel?>(null);
  final Rx<TipoEnvio> tipoEnvio = TipoEnvio.normal.obs;
  final RxDouble costoEnvioPersonalizado = 0.0.obs;
  
  // Totales
  final RxDouble subtotal = 0.0.obs;
  final RxDouble costoEnvio = 0.0.obs;
  final RxDouble total = 0.0.obs;
  
  // Notas
  final RxString notas = ''.obs;
  
  // Configuración global
  late ConfiguracionModel configuracion;
  
  // Inicializar servicio
  Future<CarritoService> init() async {
    try {
      cargando.value = true;
      error.value = '';
      
      // Cargar configuración global
      configuracion = await _configuracionProvider.obtenerConfiguracion();
      
      // Actualizar costo de envío por defecto
      costoEnvio.value = configuracion.costoEnvioNormal;
      
      return this;
    } catch (e) {
      error.value = 'Error al inicializar: $e';
      print(error.value);
      return this;
    } finally {
      cargando.value = false;
    }
  }
  
  // Agregar item al carrito
  void agregarItem(ItemVentaModel item) {
    items.add(item);
    recalcularTotales();
  }
  
  // Eliminar item del carrito
  void eliminarItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      recalcularTotales();
    }
  }
  
  // Limpiar carrito
  void limpiarCarrito() {
    items.clear();
    clienteSeleccionado.value = null;
    tipoEnvio.value = TipoEnvio.normal;
    costoEnvioPersonalizado.value = 0.0;
    notas.value = '';
    recalcularTotales();
  }
  
  // Seleccionar cliente
  void seleccionarCliente(ClienteModel cliente) {
    clienteSeleccionado.value = cliente;
  }
  
  // Seleccionar tipo de envío
  void seleccionarTipoEnvio(TipoEnvio tipo) {
    tipoEnvio.value = tipo;
    
    switch (tipo) {
      case TipoEnvio.normal:
        costoEnvio.value = configuracion.costoEnvioNormal;
        break;
      case TipoEnvio.express:
        costoEnvio.value = configuracion.costoEnvioExpress;
        break;
      case TipoEnvio.personalizado:
        costoEnvio.value = costoEnvioPersonalizado.value;
        break;
    }
    
    recalcularTotales();
  }
  
  // Establecer costo de envío personalizado
  void setCostoEnvioPersonalizado(double costo) {
    costoEnvioPersonalizado.value = costo;
    if (tipoEnvio.value == TipoEnvio.personalizado) {
      costoEnvio.value = costo;
      recalcularTotales();
    }
  }
  
  // Establecer notas
  void setNotas(String texto) {
    notas.value = texto;
  }
  
  // Recalcular totales
  void recalcularTotales() {
    // Calcular subtotal
    double subtotalTemp = 0.0;
    for (var item in items) {
      subtotalTemp += item.precioTotal;
    }
    
    subtotal.value = subtotalTemp;
    
    // Aplicar reglas especiales
    _aplicarReglasEspeciales();
    
    // Calcular total
    total.value = subtotal.value + costoEnvio.value;
  }
  
  // Aplicar reglas especiales
  void _aplicarReglasEspeciales() {
    // Regla: Redes Sociales, 3 por Q90 con envío incluido
    // Esta regla se aplicaría según lógica de negocio específica
    // Por ahora, solo dejamos el código comentado como ejemplo
    
    /*
    // Verificar si tenemos 3 stickers de tamaño cuarto
    if (items.length == 3 && 
        items.every((item) => item.tamano == TamanoSticker.cuarto && item.cantidad == 1)) {
      // Aplicar precio fijo con envío incluido
      subtotal.value = configuracion.precioRedesSociales;
      costoEnvio.value = 0.0; // Ya incluido
    }
    */
  }
  
  // Crear cotización
  Future<String> crearCotizacion() async {
    if (items.isEmpty) {
      error.value = 'El carrito está vacío';
      return '';
    }
    
    if (clienteSeleccionado.value == null) {
      error.value = 'Seleccione un cliente';
      return '';
    }
    
    try {
      cargando.value = true;
      error.value = '';
      
      VentaModel venta = VentaModel(
        clienteId: clienteSeleccionado.value!.id,
        nombreCliente: clienteSeleccionado.value!.nombre,
        fecha: DateTime.now(),
        estado: EstadoVenta.cotizacion,
        items: List.from(items),
        tipoEnvio: tipoEnvio.value,
        costoEnvio: costoEnvio.value,
        subtotal: subtotal.value,
        total: total.value,
        notas: notas.value,
      );
      
      String id = await _ventasProvider.crearVenta(venta);
      
      // Limpiar carrito después de crear la cotización
      limpiarCarrito();
      
      return id;
    } catch (e) {
      error.value = 'Error al crear cotización: $e';
      print(error.value);
      return '';
    } finally {
      cargando.value = false;
    }
  }
  
  // Crear venta directa (completada)
  Future<String> crearVenta() async {
    if (items.isEmpty) {
      error.value = 'El carrito está vacío';
      return '';
    }
    
    if (clienteSeleccionado.value == null) {
      error.value = 'Seleccione un cliente';
      return '';
    }
    
    try {
      cargando.value = true;
      error.value = '';
      
      VentaModel venta = VentaModel(
        clienteId: clienteSeleccionado.value!.id,
        nombreCliente: clienteSeleccionado.value!.nombre,
        fecha: DateTime.now(),
        estado: EstadoVenta.completada, // Directamente completada
        items: List.from(items),
        tipoEnvio: tipoEnvio.value,
        costoEnvio: costoEnvio.value,
        subtotal: subtotal.value,
        total: total.value,
        notas: notas.value,
      );
      
      String id = await _ventasProvider.crearVenta(venta);
      
      // Limpiar carrito después de crear la venta
      limpiarCarrito();
      
      return id;
    } catch (e) {
      error.value = 'Error al crear venta: $e';
      print(error.value);
      return '';
    } finally {
      cargando.value = false;
    }
  }
  
  // Verificar si el carrito contiene el paquete de redes sociales
  bool esPromoRedesSociales() {
    return items.length == 3 && 
        items.every((item) => item.tamano == TamanoSticker.cuarto && item.cantidad == 1);
  }
  
  // Aplicar promoción de redes sociales
  void aplicarPromoRedesSociales() {
    if (esPromoRedesSociales()) {
      subtotal.value = configuracion.precioRedesSociales;
      costoEnvio.value = 0.0; // Envío incluido
      total.value = subtotal.value;
    }
  }
}