import 'package:flowtrack/bar%20graph/bar_graph.dart';
import 'package:flowtrack/data/expenses_data.dart';
import 'package:flowtrack/dateTime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  //calculate max amount in the bar graph
  double calculateMax(
    ExpensesData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double max = 100;
    List<double> values = [
      value.calculatedailyExpenseSummary()[sunday] ?? 0,
      value.calculatedailyExpenseSummary()[monday] ?? 0,
      value.calculatedailyExpenseSummary()[tuesday] ?? 0,
      value.calculatedailyExpenseSummary()[wednesday] ?? 0,
      value.calculatedailyExpenseSummary()[thursday] ?? 0,
      value.calculatedailyExpenseSummary()[friday] ?? 0,
      value.calculatedailyExpenseSummary()[saturday] ?? 0,
    ];

    //sort from smallest to largest
    values.sort();
    //get the largest value (which is the end of the sorted list)
    //and increase the cap slightly so the graphs looks almost full
    max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  //calculate total expense for the week
  String calculateWeekTotal(
    ExpensesData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    // FIX: The extra curly brace block has been removed.
    List<double> values = [
      value.calculatedailyExpenseSummary()[sunday] ?? 0,
      value.calculatedailyExpenseSummary()[monday] ?? 0,
      value.calculatedailyExpenseSummary()[tuesday] ?? 0,
      value.calculatedailyExpenseSummary()[wednesday] ?? 0,
      value.calculatedailyExpenseSummary()[thursday] ?? 0,
      value.calculatedailyExpenseSummary()[friday] ?? 0,
      value.calculatedailyExpenseSummary()[saturday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }

    return total.toStringAsFixed(2);
  }

  // FIX: The build method was placed incorrectly inside the previous function.
  // It has been moved to its correct position within the class.
  @override
  Widget build(BuildContext context) {
    //get yyyymmdd for each day of the week
    String sunday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 0)),
    );
    String monday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 1)),
    );
    String tuesday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 2)),
    );
    String wednesday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 3)),
    );
    String thursday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 4)),
    );
    String friday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 5)),
    );
    String saturday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 6)),
    );

    return Consumer<ExpensesData>(
      builder: (context, value, child) => Column(
        children: [
          // week total
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                const Text(
                  'Week Total: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // FIX: Corrected string interpolation to display the currency symbol
                // followed by the calculated total.
                Text(
                  '${value.currencySymbol}${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                ),
              ],
            ),
          ),

          // bar graph
          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMax(
                value,
                sunday,
                monday,
                tuesday,
                wednesday,
                thursday,
                friday,
                saturday,
              ),
              sunAmount: value.calculatedailyExpenseSummary()[sunday] ?? 0,
              monAmount: value.calculatedailyExpenseSummary()[monday] ?? 0,
              tueAmount: value.calculatedailyExpenseSummary()[tuesday] ?? 0,
              wedAmount: value.calculatedailyExpenseSummary()[wednesday] ?? 0,
              thurAmount: value.calculatedailyExpenseSummary()[thursday] ?? 0,
              friAmount: value.calculatedailyExpenseSummary()[friday] ?? 0,
              satAmount: value.calculatedailyExpenseSummary()[saturday] ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
