import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'database_helper.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() =>
      _ReportsScreenState();
}

class _ReportsScreenState
    extends State<ReportsScreen> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() async {
    final data =
        await DatabaseHelper.getTransactions();
    setState(() {
      transactions = data;
    });
  }

  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => !t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Reports',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        iconTheme:
            IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.green[200]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Income',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '₹${totalIncome.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.red[200]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Expenses',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '₹${totalExpense.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            if (totalIncome > 0 || totalExpense > 0)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Income vs Expenses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: totalIncome,
                              title: 'Income',
                              color: Colors.green,
                              radius: 80,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            PieChartSectionData(
                              value: totalExpense,
                              title: 'Expense',
                              color: Colors.red,
                              radius: 80,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          color: Colors.green,
                        ),
                        SizedBox(width: 4),
                        Text('Income'),
                        SizedBox(width: 16),
                        Container(
                          width: 12,
                          height: 12,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4),
                        Text('Expenses'),
                      ],
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Add transactions to see charts!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Transactions',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${transactions.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}