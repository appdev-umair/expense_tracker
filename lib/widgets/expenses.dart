import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/add_expense.dart';
import 'package:expense_tracker/widgets/charts/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({
    super.key,
  });

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        category: Category.work,
        date: DateTime.now()),
    Expense(
        title: "Cinema",
        amount: 15,
        category: Category.leisure,
        date: DateTime.now()),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      constraints: const BoxConstraints().copyWith(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return AddExpenseOverlay(
          onAddExpense: _addExpense,
        );
      },
    );
  }

  void _addExpense({required Expense expense}) {
    setState(() {
      _registerExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerExpenses.indexOf(expense);
    setState(() {
      _registerExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Expense Deleted."),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registerExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    Widget content = const Center(child: Text("No Expense!"));
    if (_registerExpenses.isNotEmpty) {
      content = ExpenseList(
        expenses: _registerExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter ExpenseTracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registerExpenses),
                Expanded(
                  child: content,
                )
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registerExpenses)),
                Expanded(
                  child: content,
                )
              ],
            ),
    );
  }
}
