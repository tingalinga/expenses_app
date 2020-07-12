import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get _groupedTransactionValues {
    return List.generate(7, (index) {
      var totalSum = 0.0;
      final currentDay = DateTime.now().subtract(Duration(days: index));

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == currentDay.day &&
            recentTransactions[i].date.month == currentDay.month &&
            recentTransactions[i].date.year == currentDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(currentDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get _totalSpending {
    return _groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data['day'],
                spendingAmount: data['amount'],
                spendingPercentage: _totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / _totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
