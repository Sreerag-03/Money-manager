
import 'package:flutter/material.dart';
import 'package:flutter_application/db/category/category_db.dart';
import 'package:flutter_application/db/transactions/transaction_db.dart';
import 'package:flutter_application/models/category/category_model.dart';
import 'package:flutter_application/models/transaction/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _purposeTextEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Purpose',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _amountTextEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Amount',
              ),
            ),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now());

                if (_selectedDateTemp == null) {
                  return;
                } else {
                  print(_selectedDateTemp.toString());
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'Select Date'
                  : _selectedDate!.toString()),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                    value: CategoryType.income,
                    groupValue: _selectedCategoryType,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategoryType = CategoryType.income;
                        _categoryID = null;
                      });
                    }),
                const Text('Income'),
                Radio(
                  value: CategoryType.expense,
                  groupValue: _selectedCategoryType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategoryType = CategoryType.expense;
                      _categoryID = null;
                    });
                  },
                ),
                const Text('Expense'),
              ],
            ),
            const SizedBox(height: 30),
            DropdownButton(
                hint: const Text('Select Category'),
                value: _categoryID,
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDB().incomeCategoryListListener
                        : CategoryDB().expenseCategoryListListener)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    _categoryID = selectedValue;
                  });
                }),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: () {
              addTransaction();
            }, child: Text('Submit'))
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;

    if (_purposeText.isEmpty) {
      return;
    }

    if (_amountText.isEmpty) {
      return;
    }

    if (_categoryID == null) {
      return;
    }

    if (_selectedDate == null) {
      return;
    }

    if(_selectedCategoryModel == null){
      return;
    }

    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );


    await TransactionDB.instance.addTrasaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
