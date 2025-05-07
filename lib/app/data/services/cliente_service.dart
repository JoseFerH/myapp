import 'package:get/get.dart';
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
      
      List<ClienteModel> listaClientes = await _clientesProvider.obtenerClientes();
      clientes.assignAll(listaClientes);
    } catch (e) {
      error.value = 'Error al cargar clientes: $e';
      print(error.value);
    } finally {
      cargando.value = false;
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
      if (clienteActual.value != null && clienteActual.value!.id == cliente.id) {
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
      
      List<VentaModel> ventas = await _ventasProvider.obtenerVentasPorCliente(clienteId);
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
}