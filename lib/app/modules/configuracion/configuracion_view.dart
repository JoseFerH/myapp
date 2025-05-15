// lib/app/modules/configuracion/configuracion_view.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/configuracion_controller.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import 'components/costos_fijos_component.dart';
import 'components/porcentajes_component.dart';
import 'components/envio_component.dart';
import 'components/diseno_component.dart';
import 'components/proyectos_component.dart';

class ConfiguracionView extends GetView<ConfiguracionController> {
  const ConfiguracionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Obx(() {
          // Mostrar loading si está cargando
          if (controller.cargando.value) {
            return const LoadingIndicator(message: 'Cargando configuración...');
          }

          // Mostrar error si existe
          if (controller.error.value.isNotEmpty) {
            return ErrorMessage(
              message: controller.error.value,
              onRetry: () => controller.onInit(),
            );
          }

          return Column(
            children: [
              // Segmented Control para seleccionar sección
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoSlidingSegmentedControl<int>(
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Costos Fijos'),
                    ),
                    1: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Porcentajes'),
                    ),
                    2: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Envíos'),
                    ),
                    3: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Diseño'),
                    ),
                    4: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Proyectos'),
                    ),
                  },
                  groupValue: controller.tabIndex.value,
                  onValueChanged: (value) {
                    if (value != null) {
                      controller.cambiarTab(value);
                    }
                  },
                ),
              ),

              // Contenido según pestaña seleccionada
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    switch (controller.tabIndex.value) {
                      case 0:
                        return const CostosFijosComponent();
                      case 1:
                        return const PorcentajesComponent();
                      case 2:
                        return const EnvioComponent();
                      case 3:
                        return const DisenoComponent();
                      case 4:
                        return const ProyectosComponent();
                      default:
                        return const CostosFijosComponent();
                    }
                  }),
                ),
              ),

              // Botón de guardar al final
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoButton.filled(
                  onPressed:
                      controller.cargando.value
                          ? null
                          : controller.guardarConfiguracion,
                  child:
                      controller.cargando.value
                          ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          )
                          : const Text('Guardar Configuración'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
