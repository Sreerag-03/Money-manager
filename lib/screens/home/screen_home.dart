import 'package:flutter/material.dart';
import 'package:flutter_application/screens/add_transactions/screen_add_transactions.dart';
import 'package:flutter_application/screens/category/category_add_popup.dart';
import 'package:flutter_application/screens/category/screen_categories.dart';
import 'package:flutter_application/screens/home/widgets/bottom_navigation.dart';
import 'package:flutter_application/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransactions(),
    ScreenCategories(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 220, 220),
      appBar: AppBar(
        title: Text('MONEY MANAGER'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, _) {
          return _pages[updatedIndex];
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print('Add transactions');
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            print('Add categories');

            showCategoryAddPopup(context);
            //final _sample = CategoryModel(
              //  id: DateTime.now().millisecondsSinceEpoch.toString(),
                //name: 'Travel',
                //type: CategoryType.expense);
            //CategoryDB().insertCategories(_sample);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
