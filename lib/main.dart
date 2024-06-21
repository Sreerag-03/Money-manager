import 'package:flutter/material.dart';
import 'package:flutter_application/db/category/category_db.dart';
import 'package:flutter_application/models/category/category_model.dart';
import 'package:flutter_application/models/transaction/transaction_model.dart';
import 'package:flutter_application/screens/add_transactions/screen_add_transactions.dart';
import 'package:flutter_application/screens/home/screen_home.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async{

  final obj1 = CategoryDB();
  final obj2 = CategoryDB();

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if(!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId))
  {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId))
  {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if(!Hive.isAdapterRegistered(TransactionModelAdapter().typeId))
  {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ScreenHome(),
      routes: {
        ScreenAddTransaction.routeName: (ctx) => const ScreenAddTransaction(), 
      },
    );
  }
}

