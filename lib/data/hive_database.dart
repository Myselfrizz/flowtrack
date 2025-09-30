import 'package:flowtrack/models/expenses_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  //refrence our box
  final _myBox = Hive.box('expense_database');

  //write data
  void saveData(List<ExpensesItem> allExpenses) {

    /*
     hive can only store strings and dateTime, and not custom objects like ExpensesItem.
     so lets convert ExpenseItem into types that can be stored in our db

     allExpense=
     [
     
       Expenseitem (name / amount / dateTime),
       ...

     ]

     ->
     [
     
     [name, amount, dateTime]
      ...
     ]

    */
   List<List<dynamic>> allExpensesFormatted = [];
   for (var expense in allExpenses) {
    //convert each expense item into a list of storable types (string, double, dateTime)
    List<dynamic> expenseFormatted = [
      expense.name,
      expense.amount,
      expense.dateTime,
    ];
    allExpensesFormatted.add(expenseFormatted);
   }

   //finally we can store data into database!!
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data
  List<ExpensesItem> readData() {
    /*
   Data is stored in Hive as a list of strings + dateTime so lets convert our saved data into ExpenseItem onjects

   saved data=

   [
   
   [name, amount, dateTime],
    ...
    ]

    [

    ->
    
    [
    
    
    Expenseitem (name / amount / dateTime),]
    
    
    ]


    */
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpensesItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      //collect individual data
      String name = savedExpenses[i][0];
      double amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      //create expense item with it
      ExpensesItem expenseItem = ExpensesItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );
      //add it to the list
      allExpenses.add(expenseItem);
    }
    return allExpenses;
  }
}
