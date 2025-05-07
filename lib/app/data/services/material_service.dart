import 'package:get/get.dart';
import '../models/material_model.dart';
import '../models/hoja_model.dart';
import '../models/laminado_model.dart';
import '../models/proveedor_model.dart';
import '../providers/materiales_provider.dart';
import '../providers/proveedores_provider.dart';

class MaterialService extends GetxService {
  final MaterialesProvider _materialesProvider = MaterialesProvider();
  final ProveedoresProvider _proveedoresProvider = ProveedoresProvider();
  
  // Rx Variables para el estado
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  
  // Rx Variables para listas
  final RxList<MaterialModel> materiales = <MaterialModel>[].obs;
  final RxList<HojaModel> hojas = <HojaModel>[].obs;
  final RxList<LaminadoModel> laminados = <LaminadoModel>[].obs;
  final RxList<ProveedorModel> proveedores = <ProveedorModel>[].obs;
  
  // Material/proveedor actual
  final Rx<MaterialModel?> materialActual = Rx<MaterialModel?>(null);
  final Rx<ProveedorModel?> proveedorActual = Rx<ProveedorModel?>(null);
  
  // Inicializar servicio
  Future<MaterialService> init() async {
    await Future.wait([
      cargarMateriales(),
      cargarProveedores()
    ]);
    
    return this;
  }
  
  // Cargar todos los materiales
  Future<void> cargarMateriales() async {
    try {
      cargando.value = true;
      error.value = '';
      
      List<MaterialModel> listaMateriales = await _materialesProvider.obtenerMateriales();
      materiales.assignAll(listaMateriales);
      
      // Filtrar por tipos
      hojas.assignAll(listaMateriales
          .where((m) => m is HojaModel)
          .map((m) => m as HojaModel)
          .toList());
          
      laminados.assignAll(listaMateriales
          .where((m) => m is LaminadoModel)
          .map((m) => m as LaminadoModel)
          .toList());
    } catch (e) {
      error.value = 'Error al cargar materiales: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Cargar todos los proveedores
  Future<void> cargarProveedores() async {
    try {
      cargando.value = true;
      error.value = '';
      
      List<ProveedorModel> listaProveedores = await _proveedoresProvider.obtenerProveedores();
      proveedores.assignAll(listaProveedores);
    } catch (e) {
      error.value = 'Error al cargar proveedores: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Cargar material por ID
  Future<MaterialModel?> cargarMaterialPorId(String id) async {
    try {
      cargando.value = true;
      error.value = '';
      
      MaterialModel material = await _materialesProvider.obtenerMaterialPorId(id);
      materialActual.value = material;
      return material;
    } catch (e) {
      error.value = 'Error al cargar material: $e';
      print(error.value);
      return null;
    } finally {
      cargando.value = false;
    }
  }
  
  // Cargar proveedor por ID
  Future<ProveedorModel?> cargarProveedorPorId(String id) async {
    try {
      cargando.value = true;
      error.value = '';
      
      ProveedorModel proveedor = await _proveedoresProvider.obtenerProveedorPorId(id);
      proveedorActual.value = proveedor;
      return proveedor;
    } catch (e) {
      error.value = 'Error al cargar proveedor: $e';
      print(error.value);
      return null;
    } finally {
      cargando.value = false;
    }
  }
  
  // Crear nueva hoja
  Future<String> crearHoja(HojaModel hoja) async {
    try {
      cargando.value = true;
      error.value = '';
      
      String id = await _materialesProvider.crearHoja(hoja);
      
      // Actualizar listas locales
      await cargarMateriales();
      
      return id;
    } catch (e) {
      error.value = 'Error al crear hoja: $e';
      print(error.value);
      return '';
    } finally {
      cargando.value = false;
    }
  }
  
  // Crear nuevo laminado
  Future<String> crearLaminado(LaminadoModel laminado) async {
    try {
      cargando.value = true;
      error.value = '';
      
      String id = await _materialesProvider.crearLaminado(laminado);
      
      // Actualizar listas locales
      await cargarMateriales();
      
      return id;
    } catch (e) {
      error.value = 'Error al crear laminado: $e';
      print(error.value);
      return '';
    } finally {
      cargando.value = false;
    }
  }
  
  // Crear nuevo proveedor
  Future<String> crearProveedor(ProveedorModel proveedor) async {
    try {
      cargando.value = true;
      error.value = '';
      
      String id = await _proveedoresProvider.crearProveedor(proveedor);
      
      // Actualizar lista local
      await cargarProveedores();
      
      return id;
    } catch (e) {
      error.value = 'Error al crear proveedor: $e';
      print(error.value);
      return '';
    } finally {
      cargando.value = false;
    }
  }
  
  // Actualizar material
  Future<bool> actualizarMaterial(MaterialModel material) async {
    try {
      cargando.value = true;
      error.value = '';
      
      await _materialesProvider.actualizarMaterial(material);
      
      // Actualizar listas locales
      await cargarMateriales();
      
      return true;
    } catch (e) {
      error.value = 'Error al actualizar material: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Actualizar proveedor
  Future<bool> actualizarProveedor(ProveedorModel proveedor) async {
    try {
      cargando.value = true;
      error.value = '';
      
      await _proveedoresProvider.actualizarProveedor(proveedor);
      
      // Actualizar lista local
      await cargarProveedores();
      
      return true;
    } catch (e) {
      error.value = 'Error al actualizar proveedor: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Eliminar material
  Future<bool> eliminarMaterial(String id) async {
    try {
      cargando.value = true;
      error.value = '';
      
      await _materialesProvider.eliminarMaterial(id);
      
      // Actualizar listas locales
      await cargarMateriales();
      
      return true;
    } catch (e) {
      error.value = 'Error al eliminar material: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Eliminar proveedor
  Future<bool> eliminarProveedor(String id) async {
    try {
      cargando.value = true;
      error.value = '';
      
      await _proveedoresProvider.eliminarProveedor(id);
      
      // Actualizar lista local
      await cargarProveedores();
      
      return true;
    } catch (e) {
      error.value = 'Error al eliminar proveedor: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Actualizar inventario (aumentar stock)
  Future<bool> aumentarStock(String materialId, int cantidad) async {
    try {
      cargando.value = true;
      error.value = '';
      
      await _materialesProvider.aumentarStock(materialId, cantidad);
      
      // Actualizar listas locales
      await cargarMateriales();
      
      return true;
    } catch (e) {
      error.value = 'Error al aumentar stock: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Actualizar inventario (reducir stock)
  Future<bool> reducirStock(String materialId, int cantidad) async {
    try {
      cargando.value = true;
      error.value = '';
      
      await _materialesProvider.reducirStock(materialId, cantidad);
      
      // Actualizar listas locales
      await cargarMateriales();
      
      return true;
    } catch (e) {
      error.value = 'Error al reducir stock: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }
  
  // Obtener materiales con bajo stock
  Future<List<MaterialModel>> obtenerMaterialesBajoStock() async {
    try {
      return await _materialesProvider.obtenerMaterialesBajoStock();
    } catch (e) {
      error.value = 'Error al obtener materiales bajo stock: $e';
      print(error.value);
      return [];
    }
  }
}