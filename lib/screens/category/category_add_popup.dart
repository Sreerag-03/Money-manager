
import 'package:flutter/material.dart';
import 'package:flutter_application/db/category/category_db.dart';
import 'package:flutter_application/models/category/category_model.dart';

ValueNotifier<CategoryType> selecteCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: _nameEditingController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Category Name',
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 3)))),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  RadioButton(title: 'Income', type: CategoryType.income),
                  RadioButton(title: 'Expense', type: CategoryType.expense),
                ],
              ),
            ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final _name = _nameEditingController.text;
                  if (_name.isEmpty) {
                    return;
                  }

                  final _type = selecteCategoryNotifier.value;
                  final _category = CategoryModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _name,
                      type: _type);

                      CategoryDB.instance.insertCategories(_category);
                      Navigator.of(ctx).pop();
                },
                child: Text('Add'),
              ),
            )
          ],
        );
      });
}


class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selecteCategoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selecteCategoryNotifier.value = value;
                  selecteCategoryNotifier.notifyListeners();
                });
          },
        ),
        Text(title)
      ],
    );
  }
}
