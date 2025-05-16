import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../models/cliente_model.dart';
import '../models/venta_model.dart';
import '../providers/clientes_provider.dart';
import '../providers/ventas_provider.dart';

class ClienteService extends GetxService {
  final ClientesProvider _clientesProvider = ClientesProvider();
  final VentasProvider _ventasProvider = VentasProvider();

  // Rx Variables para el estado
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;

  // Rx Variables para listas
  final RxList<ClienteModel> clientes = <ClienteModel>[].obs;
  final RxList<VentaModel> historialVentas = <VentaModel>[].obs;

  // Cliente actual
  final Rx<ClienteModel?> clienteActual = Rx<ClienteModel?>(null);

  // Inicializar servicio
  Future<ClienteService> init() async {
    await cargarClientes();
    return this;
  }

  // Cargar todos los clientes
  Future<void> cargarClientes() async {
    try {
      cargando.value = true;
      error.value = '';

      List<ClienteModel> listaClientes =
          await _clientesProvider.obtenerClientes();
      clientes.assignAll(listaClientes);
    } catch (e) {
      error.value = 'Error al cargar clientes: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Agregar el método que falta: obtenerClientes
  Future<List<ClienteModel>> obtenerClientes() async {
    try {
      if (clientes.isEmpty) {
        await cargarClientes();
      }
      return clientes.toList();
    } catch (e) {
      error.value = 'Error al obtener clientes: $e';
      print(error.value);
      return [];
    }
  }

  // Cargar cliente por ID
  Future<ClienteModel?> cargarClientePorId(String id) async {
    try {
      cargando.value = true;
      error.value = '';

      ClienteModel cliente = await _clientesProvider.obtenerClientePorId(id);
      clienteActual.value = cliente;
      return cliente;
    } catch (e) {
      error.value = 'Error al cargar cliente: $e';
      print(error.value);
      return null;
    } finally {
      cargando.value = false;
    }
  }

  // Buscar clientes
  Future<List<ClienteModel>> buscarClientes(String query) async {
    try {
      if (query.isEmpty) {
        return clientes;
      }

      return await _clientesProvider.buscarClientes(query);
    } catch (e) {
      error.value = 'Error al buscar clientes: $e';
      print(error.value);
      return [];
    }
  }

  // Crear nuevo cliente
  Future<String> crearCliente(ClienteModel cliente) async {
    try {
      cargando.value = true;
      error.value = '';

      String id = await _clientesProvider.crearCliente(cliente);

      // Actualizar lista local
      await cargarClientes();

      return id;
    } catch (e) {
      error.value = 'Error al crear cliente: $e';
      print(error.value);
      return '';
    } finally {
      cargando.value = false;
    }
  }

  // Actualizar cliente
  Future<bool> actualizarCliente(ClienteModel cliente) async {
    try {
      cargando.value = true;
      error.value = '';

      await _clientesProvider.actualizarCliente(cliente);

      // Actualizar lista local
      await cargarClientes();

      // Actualizar cliente actual si es el mismo
      if (clienteActual.value != null &&
          clienteActual.value!.id == cliente.id) {
        clienteActual.value = cliente;
      }

      return true;
    } catch (e) {
      error.value = 'Error al actualizar cliente: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  // Eliminar cliente
  Future<bool> eliminarCliente(String id) async {
    try {
      cargando.value = true;
      error.value = '';

      await _clientesProvider.eliminarCliente(id);

      // Actualizar lista local
      await cargarClientes();

      // Limpiar cliente actual si es el mismo
      if (clienteActual.value != null && clienteActual.value!.id == id) {
        clienteActual.value = null;
      }

      return true;
    } catch (e) {
      error.value = 'Error al eliminar cliente: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  // Cargar historial de ventas del cliente
  Future<List<VentaModel>> cargarHistorialVentas(String clienteId) async {
    try {
      cargando.value = true;
      error.value = '';

      List<VentaModel> ventas = await _ventasProvider.obtenerVentasPorCliente(
        clienteId,
      );
      historialVentas.assignAll(ventas);
      return ventas;
    } catch (e) {
      error.value = 'Error al cargar historial: $e';
      print(error.value);
      return [];
    } finally {
      cargando.value = false;
    }
  }

  // Obtener top clientes
  Future<List<ClienteModel>> obtenerTopClientes(int limite) async {
    try {
      return await _clientesProvider.obtenerTopClientes(limite);
    } catch (e) {
      error.value = 'Error al obtener top clientes: $e';
      print(error.value);
      return [];
    }
  }

  // *** NUEVA FUNCIONALIDAD: ACTUALIZACIÓN AUTOMÁTICA DE TIPO DE CLIENTE ***

  // Método para incrementar compras y actualizar estado del cliente
  Future<bool> incrementarComprasCliente(
    String clienteId,
    double montoVenta,
  ) async {
    try {
      error.value = '';

      // Obtener cliente actual
      ClienteModel? cliente;

      try {
        cliente = await _clientesProvider.obtenerClientePorId(clienteId);
      } catch (e) {
        error.value = 'Cliente no encontrado: $e';
        return false;
      }

      if (cliente == null) {
        error.value = 'Cliente no encontrado';
        return false;
      }

      // Incrementar compras y total gastado
      int nuevasCompras = cliente.comprasRealizadas + 1;
      double nuevoTotal = cliente.totalGastado + montoVenta;

      // Determinar si el tipo debe actualizarse automáticamente
      String nuevoTipo = cliente.tipoCliente;
      bool cambioTipo = false;

      // Solo actualizar automáticamente si el tipo actual coincide con el calculado para las compras anteriores
      String tipoEsperado = ClienteModel.determinarTipoCliente(
        cliente.comprasRealizadas,
      );
      if (cliente.tipoCliente == tipoEsperado) {
        String nuevoTipoCalculado = ClienteModel.determinarTipoCliente(
          nuevasCompras,
        );
        if (nuevoTipoCalculado != tipoEsperado) {
          nuevoTipo = nuevoTipoCalculado;
          cambioTipo = true;
        }
      }

      // Actualizar cliente con los nuevos valores
      ClienteModel clienteActualizado = cliente.copyWith(
        comprasRealizadas: nuevasCompras,
        totalGastado: nuevoTotal,
        tipoCliente: nuevoTipo,
      );

      // Actualizar en base de datos
      await _clientesProvider.actualizarCliente(clienteActualizado);

      // Actualizar en lista local
      await cargarClientes();

      // Si el cliente alcanzó el nivel VIP, mostrar notificación
      if (cambioTipo && nuevoTipo == 'VIP') {
        _mostrarNotificacionClienteVIP(cliente.nombre);
      } else if (cambioTipo) {
        _mostrarNotificacionCambioTipo(cliente.nombre, nuevoTipo);
      }

      return true;
    } catch (e) {
      error.value = 'Error al actualizar compras de cliente: $e';
      print(error.value);
      return false;
    }
  }

  // Mostrar notificación cuando un cliente alcanza el nivel VIP
  void _mostrarNotificacionClienteVIP(String nombreCliente) {
    Get.snackbar(
      '¡Cliente VIP!',
      '$nombreCliente ha alcanzado el estado VIP tras 100 compras.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: CupertinoColors.activeGreen.withOpacity(0.9),
      colorText: CupertinoColors.white,
      duration: Duration(seconds: 5),
      icon: Icon(CupertinoIcons.star_fill, color: CupertinoColors.white),
    );
  }

  // Mostrar notificación para otros cambios de tipo
  void _mostrarNotificacionCambioTipo(String nombreCliente, String nuevoTipo) {
    Get.snackbar(
      'Cliente Actualizado',
      '$nombreCliente ahora es cliente $nuevoTipo',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }
}
