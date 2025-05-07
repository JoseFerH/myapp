// lib/app/controllers/registros_controller.dart

import 'package:get/get.dart';
import '../data/models/cliente_model.dart';
import '../data/models/proveedor_model.dart';
import '../data/models/material_model.dart';
import '../data/models/hoja_model.dart';
import '../data/models/laminado_model.dart';
import '../data/services/cliente_service.dart';
import '../data/services/material_service.dart';

class RegistrosController extends GetxController {
  // Servicios
  final ClienteService _clienteService = Get.find<ClienteService>();
  final MaterialService _materialService = Get.find<MaterialService>();
  
  // Variables reactivas de UI
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  final RxInt tabIndex = 0.obs; // 0: Clientes, 1: Proveedores, 2: Inventario
  final RxString filtroTexto = ''.obs;
  
  // Datos
  final RxList<ClienteModel> clientes = <ClienteModel>[].obs;
  final RxList<ProveedorModel> proveedores = <ProveedorModel>[].obs;
  final RxList<MaterialModel> materiales = <MaterialModel>[].obs;
  final RxList<HojaModel> hojas = <HojaModel>[].obs;
  final RxList<LaminadoModel> laminados = <LaminadoModel>[].obs;
  
  // Elementos seleccionados
  final Rx<ClienteModel?> clienteSeleccionado = Rx<ClienteModel?>(null);
  final Rx<ProveedorModel?> proveedorSeleccionado = Rx<ProveedorModel?>(null);
  final Rx<MaterialModel?> materialSeleccionado = Rx<MaterialModel?>(null);
  
  @override
  void onInit() async {
    super.onInit();
    cargando.value = true;
    try {
      // Cargar datos iniciales
      await Future.wait([
        cargarClientes(),
        cargarProveedores(),
        cargarMateriales()
      ]);
    } catch (e) {
      error.value = 'Error al inicializar: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Cambiar pestaña
  void cambiarTab(int index) {
    tabIndex.value = index;
  }
  
  // Cargar clientes
Future<void> cargarClientes() async {
  try {
    error.value = '';
    
    // Primero llamamos al método que actualiza la lista interna en el servicio
    await _clienteService.cargarClientes();
    
    // Luego accedemos a la lista actualizada desde el servicio
    clientes.assignAll(_clienteService.clientes);
  } catch (e) {
    error.value = 'Error al cargar clientes: $e';
    print(error.value);
  }
}
  
  // Cargar proveedores
  Future<void> cargarProveedores() async {
    try {
      error.value = '';
      await _materialService.cargarProveedores();
      proveedores.assignAll(_materialService.proveedores);
    } catch (e) {
      error.value = 'Error al cargar proveedores: $e';
      print(error.value);
    }
  }
  
  // Cargar materiales
  Future<void> cargarMateriales() async {
    try {
      error.value = '';
      await _materialService.cargarMateriales();
      materiales.assignAll(_materialService.materiales);
      hojas.assignAll(_materialService.hojas);
      laminados.assignAll(_materialService.laminados);
    } catch (e) {
      error.value = 'Error al cargar materiales: $e';
      print(error.value);
    }
  }
  
  // Métodos para clientes
  Future<bool> crearCliente(ClienteModel cliente) async {
    try {
      cargando.value = true;
      error.value = '';
      
      String id = await _clienteService.crearCliente(cliente);
      if (id.isNotEmpty) {
        await cargarClientes();
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Error al crear cliente: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  Future<bool> actualizarCliente(ClienteModel cliente) async {
    try {
      cargando.value = true;
      error.value = '';
      
      bool result = await _clienteService.actualizarCliente(cliente);
      if (result) {
        await cargarClientes();
      }
      return result;
    } catch (e) {
      error.value = 'Error al actualizar cliente: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  Future<bool> eliminarCliente(String id) async {
    try {
      cargando.value = true;
      error.value = '';
      
      bool result = await _clienteService.eliminarCliente(id);
      if (result) {
        await cargarClientes();
      }
      return result;
    } catch (e) {
      error.value = 'Error al eliminar cliente: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Métodos para proveedores
  Future<bool> crearProveedor(ProveedorModel proveedor) async {
    try {
      cargando.value = true;
      error.value = '';
      
      String id = await _materialService.crearProveedor(proveedor);
      if (id.isNotEmpty) {
        await cargarProveedores();
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Error al crear proveedor: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  Future<bool> actualizarProveedor(ProveedorModel proveedor) async {
    try {
      cargando.value = true;
      error.value = '';
      
      bool result = await _materialService.actualizarProveedor(proveedor);
      if (result) {
        await cargarProveedores();
      }
      return result;
    } catch (e) {
      error.value = 'Error al actualizar proveedor: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  Future<bool> eliminarProveedor(String id) async {
    try {
      cargando.value = true;
      error.value = '';
      
      bool result = await _materialService.eliminarProveedor(id);
      if (result) {
        await cargarProveedores();
      }
      return result;
    } catch (e) {
      error.value = 'Error al eliminar proveedor: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Métodos para materiales
  Future<bool> crearHoja(HojaModel hoja) async {
    try {
      cargando.value = true;
      error.value = '';
      
      String id = await _materialService.crearHoja(hoja);
      if (id.isNotEmpty) {
        await cargarMateriales();
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Error al crear hoja: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  Future<bool> crearLaminado(LaminadoModel laminado) async {
    try {
      cargando.value = true;
      error.value = '';
      
      String id = await _materialService.crearLaminado(laminado);
      if (id.isNotEmpty) {
        await cargarMateriales();
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Error al crear laminado: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  Future<bool> actualizarMaterial(MaterialModel material) async {
    try {
      cargando.value = true;
      error.value = '';
      
      bool result = await _materialService.actualizarMaterial(material);
      if (result) {
        await cargarMateriales();
      }
      return result;
    } catch (e) {
      error.value = 'Error al actualizar material: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  Future<bool> eliminarMaterial(String id) async {
    try {
      cargando.value = true;
      error.value = '';
      
      bool result = await _materialService.eliminarMaterial(id);
      if (result) {
        await cargarMateriales();
      }
      return result;
    } catch (e) {
      error.value = 'Error al eliminar material: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Actualizar inventario
  Future<bool> aumentarStock(String materialId, int cantidad) async {
    try {
      cargando.value = true;
      error.value = '';
      
      bool result = await _materialService.aumentarStock(materialId, cantidad);
      if (result) {
        await cargarMateriales();
      }
      return result;
    } catch (e) {
      error.value = 'Error al aumentar stock: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  Future<bool> reducirStock(String materialId, int cantidad) async {
    try {
      cargando.value = true;
      error.value = '';
      
      bool result = await _materialService.reducirStock(materialId, cantidad);
      if (result) {
        await cargarMateriales();
      }
      return result;
    } catch (e) {
      error.value = 'Error al reducir stock: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Filtrar por texto
  void setFiltro(String texto) {
    filtroTexto.value = texto.toLowerCase();
  }
  
  // Listas filtradas
  List<ClienteModel> get clientesFiltrados {
    if (filtroTexto.isEmpty) return clientes;
    return clientes.where((c) => 
      c.nombre.toLowerCase().contains(filtroTexto.value) ||
      c.direccion.toLowerCase().contains(filtroTexto.value) ||
      c.zona.toLowerCase().contains(filtroTexto.value)
    ).toList();
  }
  
  List<ProveedorModel> get proveedoresFiltrados {
    if (filtroTexto.isEmpty) return proveedores;
    return proveedores.where((p) => 
      p.nombre.toLowerCase().contains(filtroTexto.value) ||
      p.contacto.toLowerCase().contains(filtroTexto.value) ||
      p.telefono.toLowerCase().contains(filtroTexto.value)
    ).toList();
  }
  
  List<MaterialModel> get materialesFiltrados {
    if (filtroTexto.isEmpty) return materiales;
    return materiales.where((m) => 
      m.nombre.toLowerCase().contains(filtroTexto.value) ||
      m.descripcion.toLowerCase().contains(filtroTexto.value)
    ).toList();
  }
}