import 'package:flutter/material.dart';

import '../../db/category/category_db.dart';
import '../../models/category/category_model.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().incomeCategoryListListener,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
            itemBuilder: (ctx, index) {
              final category = newList[index];
              return Card(
                child: ListTile(
                  title: Text(category.name),
                  trailing:
                      IconButton(onPressed: () {
                        CategoryDB.instance.deleteCategories(category.id);
                      }, icon: Icon(Icons.delete)),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return SizedBox(height: 10);
            },
            itemCount: newList.length);
      },
    );
  }
}
