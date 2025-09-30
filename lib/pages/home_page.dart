import 'package:flowtrack/components/Expense_tile.dart';
import 'package:flowtrack/data/expenses_data.dart';
import 'package:flowtrack/models/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flowtrack/components/expense_summary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameContoller = TextEditingController();
  final newExpenseAmountContoller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // prepare data of startup
    Provider.of<ExpensesData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense Name
            TextField(
              controller: newExpenseNameContoller,
              decoration: (const InputDecoration(hintText: 'Expense Name')),
            ),

            //expense Amount
            TextField(
              keyboardType: TextInputType.number,
              controller: newExpenseAmountContoller,
              decoration: (const InputDecoration(hintText: 'Amount')),
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(onPressed: save, child: const Text('Save')),

          // cancel button
          MaterialButton(onPressed: cancel, child: const Text('Cancel')),
        ],
      ),
    );
  }

  //delete the expense
  void deleteExpense(ExpensesItem expense) {
    Provider.of<ExpensesData>(context, listen: false).deleteExpense(expense);
  }

  // FIX: save, cancel, and clear methods were moved out of each other
  // and placed directly within the class.
  void save() {
    // FIX: The extra curly braces have been removed.
    if (newExpenseNameContoller.text.isNotEmpty &&
        newExpenseAmountContoller.text.isNotEmpty) {
      ExpensesItem newExpense = ExpensesItem(
        name: newExpenseNameContoller.text,
        amount: double.parse(newExpenseAmountContoller.text),
        dateTime: DateTime.now(),
      );
      Provider.of<ExpensesData>(
        context,
        listen: false,
      ).addNewExpense(newExpense);
    }
    // FIX: This pop was inside the `if` block, but it should be outside
    // to ensure the dialog closes even if the fields are empty.
    Navigator.pop(context);
    clear();
  }

  // FIX: Moved to its own method
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // FIX: Moved to its own method
  void clear() {
    newExpenseNameContoller.clear();
    newExpenseAmountContoller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          shape: const CircleBorder(),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            // weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),

            const SizedBox(height: 20),

            // expenses list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getExpenseList()[index].name,
                amount: value.getExpenseList()[index].amount.toString(),
                dateTime: value.getExpenseList()[index].dateTime,
                deleteTapped: (p0) =>
                    deleteExpense(value.getExpenseList()[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}