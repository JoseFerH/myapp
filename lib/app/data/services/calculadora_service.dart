import 'package:get/get.dart';
import '../models/material_model.dart';
import '../models/hoja_model.dart';
import '../models/laminado_model.dart';
import '../models/costo_fijo_model.dart';
import '../models/configuracion_model.dart';
import '../models/item_venta_model.dart';
import '../providers/materiales_provider.dart';
import '../providers/configuracion_provider.dart';

class CalculadoraService extends GetxService {
  final MaterialesProvider _materialesProvider = MaterialesProvider();
  final ConfiguracionProvider _configuracionProvider = ConfiguracionProvider();
  
  // Rx Variables para el estado
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  
  // Variables para el cálculo
  final Rx<HojaModel?> hojaSeleccionada = Rx<HojaModel?>(null);
  final Rx<LaminadoModel?> laminadoSeleccionada = Rx<LaminadoModel?>(null);
  final Rx<TamanoSticker> tamanoSeleccionado = TamanoSticker.cuarto.obs;
  final Rx<TipoDiseno> tipoDiseno = TipoDiseno.estandar.obs;
  final RxDouble precioDiseno = 0.0.obs;
  final RxBool aplicarDesperdicio = true.obs;
  final RxInt cantidad = 1.obs;
  
  // Resultados del cálculo
  final RxDouble costoMateriales = 0.0.obs;
  final RxDouble costosFijos = 0.0.obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble ganancia = 0.0.obs;
  final RxDouble precioUnitario = 0.0.obs;
  final RxDouble precioTotal = 0.0.obs;
  
  // Configuración global
  late ConfiguracionModel configuracion;
  
  // Lista de costos fijos
  RxList<CostoFijoModel> listaCostosFijos = <CostoFijoModel>[].obs;
  
  // Listas de materiales disponibles
  RxList<HojaModel> hojas = <HojaModel>[].obs;
  RxList<LaminadoModel> laminados = <LaminadoModel>[].obs;
  
  // Inicializar servicio
  Future<CalculadoraService> init() async {
    try {
      cargando.value = true;
      error.value = '';
      
      // Cargar configuración global
      configuracion = await _configuracionProvider.obtenerConfiguracion();
      
      // Cargar costos fijos
      List<CostoFijoModel> costos = await _configuracionProvider.obtenerCostosFijos();
      listaCostosFijos.assignAll(costos);
      
      // Cargar materiales disponibles
      await cargarMateriales();
      
      // Inicializar valores por defecto
      aplicarDesperdicio.value = configuracion.aplicarDesperdicioDefault;
      
      return this;
    } catch (e) {
      error.value = 'Error al inicializar: $e';
      print(error.value);
      return this;
    } finally {
      cargando.value = false;
    }
  }
  
  // Cargar materiales disponibles
  Future<void> cargarMateriales() async {
    try {
      // Cargar hojas
      List<HojaModel> listaHojas = await _materialesProvider.obtenerHojas();
      hojas.assignAll(listaHojas.where((hoja) => hoja.cantidadDisponible > 0));
      
      // Cargar laminados
      List<LaminadoModel> listaLaminados = await _materialesProvider.obtenerLaminados();
      laminados.assignAll(listaLaminados.where((laminado) => laminado.cantidadDisponible > 0));
      
      // Seleccionar el primer material de cada tipo si la lista no está vacía
      if (hojas.isNotEmpty && hojaSeleccionada.value == null) {
        hojaSeleccionada.value = hojas.first;
      }
      
      if (laminados.isNotEmpty && laminadoSeleccionada.value == null) {
        laminadoSeleccionada.value = laminados.first;
      }
    } catch (e) {
      error.value = 'Error al cargar materiales: $e';
      print(error.value);
    }
  }
  
  // Calcular precio según las selecciones actuales
  void calcularPrecio() {
    if (hojaSeleccionada.value == null || laminadoSeleccionada.value == null) {
      error.value = 'Seleccione los materiales';
      return;
    }
    
    try {
      error.value = '';
      
      // 1. Calcular costo de materiales según el tamaño
      double costoHoja = _calcularCostoMaterialSegunTamano(hojaSeleccionada.value!.precioUnitario);
      double costoLaminado = _calcularCostoMaterialSegunTamano(laminadoSeleccionada.value!.precioUnitario);
      double costoTinta = _calcularCostoTinta();
      
      costoMateriales.value = costoHoja + costoLaminado + costoTinta;
      
      // 2. Sumar costos fijos
      costosFijos.value = _calcularCostosFijos();
      
      // 3. Aplicar desperdicio si está activado
      double subtotalTemp = costoMateriales.value + costosFijos.value;
      if (aplicarDesperdicio.value) {
        subtotalTemp += subtotalTemp * (configuracion.porcentajeDesperdicio / 100);
      }
      
      // 4. Añadir costo de diseño
      double costoDiseno = 0.0;
      if (tipoDiseno.value == TipoDiseno.estandar) {
        costoDiseno = configuracion.precioDisenioEstandar;
      } else {
        costoDiseno = precioDiseno.value;
      }
      
      subtotalTemp += costoDiseno;
      subtotal.value = subtotalTemp;
      
      // 5. Calcular ganancia
      double porcentajeGanancia = configuracion.porcentajeGananciasDefault;
      ganancia.value = subtotal.value * (porcentajeGanancia / 100);
      
      // 6. Calcular precio unitario
      precioUnitario.value = subtotal.value + ganancia.value;
      
      // 7. Aplicar reglas especiales según cantidad y tamaño
      _aplicarReglasEspeciales();
      
      // 8. Calcular precio total
      precioTotal.value = precioUnitario.value * cantidad.value;
      
    } catch (e) {
      error.value = 'Error en el cálculo: $e';
      print(error.value);
    }
  }
  
  // Calcular costo de material según tamaño seleccionado
  double _calcularCostoMaterialSegunTamano(double precioBase) {
    switch (tamanoSeleccionado.value) {
      case TamanoSticker.cuarto:
        return precioBase / 4;
      case TamanoSticker.medio:
        return precioBase / 2;
      case TamanoSticker.tresQuartos:
        return precioBase * 0.75;
      case TamanoSticker.completo:
        return precioBase;
      default:
        return precioBase / 4;
    }
  }
  
  // Calcular costo de tinta (simulado según tamaño)
  double _calcularCostoTinta() {
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
  
  // Calcular costos fijos totales
  double _calcularCostosFijos() {
    double total = 0.0;
    
    // Sumar todos los costos fijos activos
    for (var costo in listaCostosFijos) {
      if (costo.activo) {
        total += costo.valor;
      }
    }
    
    return total;
  }
  
  // Aplicar reglas especiales de precios
  void _aplicarReglasEspeciales() {
    // Regla 1: 1/4 De hoja a Q20, 1/2 Hoja en adelante a Q15 c/u
    if (tamanoSeleccionado.value == TamanoSticker.cuarto) {
      precioUnitario.value = configuracion.precioCuartoHoja;
    } else if (tamanoSeleccionado.value == TamanoSticker.medio || 
               tamanoSeleccionado.value == TamanoSticker.tresQuartos || 
               tamanoSeleccionado.value == TamanoSticker.completo) {
      precioUnitario.value = configuracion.precioMediaHoja;
    }
    
    // Regla 2: A partir de 100 1/4 de Hoja, cada 1/4 de Hoja costará Q10 Con diseño Incluido
    if (tamanoSeleccionado.value == TamanoSticker.cuarto && 
        cantidad.value >= configuracion.cantidadMayorista) {
      precioUnitario.value = configuracion.precioMayorista;
    }
    
    // Regla 3: Redes Sociales, 3 por Q90 con envío incluido
    // Esta regla se aplicará en el servicio de carrito ya que involucra envío
  }
  
  // Crear un ItemVentaModel con los datos actuales
  ItemVentaModel crearItemVenta() {
    if (hojaSeleccionada.value == null || laminadoSeleccionada.value == null) {
      throw Exception('Seleccione los materiales');
    }
    
    // Calcular el precio actual
    calcularPrecio();
    
    return ItemVentaModel(
      hojaId: hojaSeleccionada.value!.id,
      nombreHoja: hojaSeleccionada.value!.nombre,
      laminadoId: laminadoSeleccionada.value!.id,
      nombreLaminado: laminadoSeleccionada.value!.nombre,
      tamano: tamanoSeleccionado.value,
      tipoDiseno: tipoDiseno.value,
      precioDiseno: tipoDiseno.value == TipoDiseno.estandar ? 
          configuracion.precioDisenioEstandar : precioDiseno.value,
      aplicarDesperdicio: aplicarDesperdicio.value,
      cantidad: cantidad.value,
      precioUnitario: precioUnitario.value,
      precioTotal: precioTotal.value,
    );
  }
  
  // Resetear los valores del cálculo
  void resetear() {
    tipoDiseno.value = TipoDiseno.estandar;
    precioDiseno.value = 0.0;
    aplicarDesperdicio.value = configuracion.aplicarDesperdicioDefault;
    cantidad.value = 1;
    tamanoSeleccionado.value = TamanoSticker.cuarto;
    
    // No resetear los materiales seleccionados para mayor comodidad
    // hojaSeleccionada.value = hojas.isNotEmpty ? hojas.first : null;
    // laminadoSeleccionada.value = laminados.isNotEmpty ? laminados.first : null;
    
    // Recalcular con los nuevos valores
    calcularPrecio();
  }
  
  // Actualizar hoja seleccionada
  void seleccionarHoja(HojaModel hoja) {
    hojaSeleccionada.value = hoja;
    calcularPrecio();
  }
  
  // Actualizar laminado seleccionado
  void seleccionarLaminado(LaminadoModel laminado) {
    laminadoSeleccionada.value = laminado;
    calcularPrecio();
  }
  
  // Actualizar tamaño
  void seleccionarTamano(TamanoSticker tamano) {
    tamanoSeleccionado.value = tamano;
    calcularPrecio();
  }
  
  // Actualizar tipo de diseño
  void seleccionarTipoDiseno(TipoDiseno tipo) {
    tipoDiseno.value = tipo;
    if (tipo == TipoDiseno.estandar) {
      precioDiseno.value = configuracion.precioDisenioEstandar;
    }
    calcularPrecio();
  }
  
  // Actualizar precio de diseño personalizado
  void cambiarPrecioDiseno(double precio) {
    precioDiseno.value = precio;
    calcularPrecio();
  }
  
  // Actualizar cantidad
  void cambiarCantidad(int nuevaCantidad) {
    if (nuevaCantidad < 1) nuevaCantidad = 1;
    cantidad.value = nuevaCantidad;
    calcularPrecio();
  }
  
  // Actualizar aplicar desperdicio
  void toggleDesperdicio(bool valor) {
    aplicarDesperdicio.value = valor;
    calcularPrecio();
  }
}