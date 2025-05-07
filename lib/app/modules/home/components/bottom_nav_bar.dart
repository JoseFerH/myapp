// lib/app/modules/home/components/bottom_nav_bar.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';

class BottomNavBar extends GetView<HomeController> {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definir los items del menú inferior
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person_2),
        label: 'Registros',
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.table),
        label: 'Visualización',
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.money_dollar_circle),
        label: 'Calculadora',
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.cart),
        label: 'Carrito',
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.graph_circle),
        label: 'Estadísticas',
      ),
    ];

    return Obx(
      () => CupertinoTabBar(
        items: items,
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        activeColor: const Color(0xFF007AFF), // Color azul iOS
        inactiveColor: CupertinoColors.systemGrey,
        border: const Border(
          top: BorderSide(
            color: CupertinoColors.systemGrey4,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}