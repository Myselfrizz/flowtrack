import 'package:flowtrack/data/hive_database.dart';
import 'package:flowtrack/dateTime/date_time_helper.dart';
import 'package:flowtrack/models/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ExpensesData extends ChangeNotifier {
  //list of all expenses
  List<ExpensesItem> OverallExpenseList = [];

  // get expense list
  List<ExpensesItem> getExpenseList() {
    return OverallExpenseList;
  }
  //prepare data to display
  final db =HiveDatabase();
  void prepareData() {
    //if there is exist data, get it
    if(db.readData().isNotEmpty){
      OverallExpenseList=db.readData();

    }
  }
  // add an expense
  void addNewExpense(ExpensesItem newExpense) {
    OverallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(OverallExpenseList);
  }

  // delete an expense
  void deleteExpense(ExpensesItem expense) {
    OverallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(OverallExpenseList);
  }


  // get weekday (mon, tues, etc.) from date and time object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get the date for the start of the week (sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get today's date
    DateTime today = DateTime.now();

    // go backwards from today to find  sunday
    for (int i = 0; i < 7; i++) {
      DateTime checkDate = today.subtract(Duration(days: i));
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  /*

  convert overall list of expenses into a daily expense summary

  e.g.

  overallExpenses = [
    [food, 2025/01/01, $10 ],
    [transport, 2025/01/01, $15 ],
    [food, 2025/01/02, $20 ],
    [entertainment, 2025/01/02, $25 ],
    [food, 2025/01/03, $30 ],
    [transport, 2025/01/03, $35 ],
    [entertainment, 2025/01/03, $40 ],
    Food, 2025/01/04, $45 ],
}

  dailyExpenseSummary = 
  
  {
    20250812 : $25,
    20250813 : $45,
    20250814 : $105,
    20250815 : $45,
  }
*/

  Map<String, double> calculatedailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date {yyy/mm/dd} : total expense for that date
    };

    for (var expense in OverallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = expense.amount;

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
