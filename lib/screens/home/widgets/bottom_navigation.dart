import 'package:flutter/material.dart';
import 'package:flutter_application/screens/home/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget? _){
        return BottomNavigationBar(
        currentIndex: updatedIndex,
        onTap: (newIndex) {
          ScreenHome.selectedIndexNotifier.value = newIndex;
        },
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Transactions'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
      ]
      );
      }
    );
  }
}
