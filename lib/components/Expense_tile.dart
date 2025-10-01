import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart'; // Make sure provider is imported
import '../data/expenses_data.dart';   // Make sure your data class is imported

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final void Function(BuildContext)? deleteTapped;

  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Get the provider data here using context.read()
    final expensesData = context.read<ExpensesData>();

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(4),
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(name),
        subtitle: Text(
          '${dateTime.day}/${dateTime.month}/${dateTime.year}',
        ),
        // 2. Use the variable you created
        trailing: Text('${expensesData.currencySymbol}$amount'),
      ),
    );
  }
}