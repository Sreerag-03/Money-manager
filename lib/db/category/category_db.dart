import 'package:flutter/foundation.dart';
import 'package:flutter_application/models/category/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDBFunctions{
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategories(CategoryModel value);
  Future<void> deleteCategories(String categoryID);
}

class CategoryDB implements CategoryDBFunctions{
  CategoryDB._internal();

  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB(){
    return instance;
  }


  ValueNotifier<List<CategoryModel>> incomeCategoryListListener = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener = ValueNotifier([]);


  @override
  Future<void> insertCategories(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreshUI();
  }
  
  @override
  Future<List<CategoryModel>> getCategories() async{
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async{
    final _allCategories = await getCategories();
    incomeCategoryListListener.value.clear();
    expenseCategoryListListener.value.clear(); 
    Future.forEach(_allCategories, (CategoryModel category) {
      if(category.type == CategoryType.income){
        incomeCategoryListListener.value.add(category);
      }
      else{
        expenseCategoryListListener.value.add(category);
      }
     }
    );

    incomeCategoryListListener.notifyListeners();
    expenseCategoryListListener.notifyListeners();
  }
  
  @override
  Future<void> deleteCategories(String categoryID) async{
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    refreshUI();
  }

}