// lib/app/routes/app_routes.dart

abstract class AppRoutes {
  // Ruta principal que contiene el bottom navigation bar
  static const HOME = '/home';

  // Rutas principales para las secciones del bottom navigation
  static const CALCULADORA = '/calculadora';
  static const CARRITO = '/carrito';
  static const REGISTROS = '/registros';
  static const VISUALIZACION = '/visualizacion';
  static const ESTADISTICAS = '/estadisticas';
  static const CONFIGURACION = '/configuracion';

  // Sub-rutas para la sección de registros
  static const CLIENTES = '/registros/clientes';
  static const PROVEEDORES = '/registros/proveedores';
  static const INVENTARIO = '/registros/inventario';

  // Rutas para detalles o visualización específica
  static const DETALLE_CLIENTE = '/registros/clientes/detalle';
  static const DETALLE_PROVEEDOR = '/registros/proveedores/detalle';
  static const DETALLE_MATERIAL = '/registros/inventario/detalle';
  static const DETALLE_VENTA = '/visualizacion/detalle';

  // Rutas para formularios de creación/edición
  static const FORM_CLIENTE = '/registros/clientes/form';
  static const FORM_PROVEEDOR = '/registros/proveedores/form';
  static const FORM_MATERIAL = '/registros/inventario/form';

  // Rutas para funcionalidades específicas
  static const COTIZACION = '/carrito/cotizacion';
  static const EXPORTACION = '/visualizacion/exportacion';
  static const NOTAS = '/notas';
}
