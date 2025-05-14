// lib/app/modules/notas/notas_view.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/notas_controller.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../widgets/empty_state.dart';
import 'components/nota_card_component.dart';
import 'components/nota_form_component.dart';
import 'components/filtro_notas_component.dart';

class NotasView extends GetView<NotasController> {
  const NotasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Mis Notas'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () => _mostrarFormularioNota(context),
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          // Mostrar loading si está cargando
          if (controller.cargando.value) {
            return const LoadingIndicator(message: 'Cargando notas...');
          }

          // Mostrar error si existe
          if (controller.error.value.isNotEmpty) {
            return ErrorMessage(
              message: controller.error.value,
              onRetry: () => controller.cargarNotas(),
            );
          }

          return Column(
            children: [
              // Filtro por categorías
              FiltroNotasComponent(),

              // Lista de notas
              Expanded(
                child: Obx(() {
                  final notas = controller.notasFiltradas;

                  if (notas.isEmpty) {
                    return EmptyState(
                      title: 'No hay notas',
                      message: 'Crea tu primera nota para comenzar',
                      icon: CupertinoIcons.doc_text,
                      buttonText: 'Crear Nota',
                      onButtonPressed: () => _mostrarFormularioNota(context),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: notas.length,
                    itemBuilder: (context, index) {
                      final nota = notas[index];
                      return NotaCardComponent(
                        nota: nota,
                        onTap: () {
                          controller.notaSeleccionada.value = nota;
                          _mostrarFormularioNota(context, nota);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Mostrar formulario para crear/editar nota
  void _mostrarFormularioNota(BuildContext context, [NotaModel? nota]) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: NotaFormComponent(nota: nota),
          ),
    );
  }
}
