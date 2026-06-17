
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'reports_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomeScreen(),
    );
  }
}



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  double get balance => totalIncome - totalExpense;

  void addTransaction(
      String title, double amount, bool isIncome) async {
    final t = Transaction(title, amount, isIncome);
    await DatabaseHelper.insertTransaction(t);
    loadTransactions();
  }

  void deleteTransaction(int index) async {
    final t = transactions[index];
    if (t.id != null) {
      await DatabaseHelper.deleteTransaction(t.id!);
    }
    loadTransactions();
  }

  void showAddTransaction() {
    String title = '';
    String amount = '';
    bool isIncome = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('Add Transaction',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText:
                      'Title (e.g. Food, Salary)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => title = val,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount (e.g. 500)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => amount = val,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Type: ',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Expense'),
                    selected: !isIncome,
                    selectedColor: Colors.red[100],
                    onSelected: (_) => setModalState(
                        () => isIncome = false),
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Income'),
                    selected: isIncome,
                    selectedColor: Colors.green[100],
                    onSelected: (_) => setModalState(
                        () => isIncome = true),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(
                        vertical: 14),
                  ),
                  onPressed: () {
                    if (title.isNotEmpty &&
                        amount.isNotEmpty) {
                      addTransaction(
                        title,
                        double.parse(amount),
                        isIncome,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add Transaction',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16)),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
  title: Text('Expense Tracker',
      style: TextStyle(color: Colors.white)),
  backgroundColor: Colors.purple,
  actions: [
    IconButton(
      icon: Icon(Icons.bar_chart,
          color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ReportsScreen()),
        );
      },
    ),
  ],
),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('Total Balance',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                SizedBox(height: 8),
                Text(
                  '₹${balance.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      Text('Income',
                          style: TextStyle(
                              color: Colors.white70)),
                      Text(
                        '₹${totalIncome.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    Column(children: [
                      Text('Expenses',
                          style: TextStyle(
                              color: Colors.white70)),
                      Text(
                        '₹${totalExpense.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('${transactions.length} items',
                    style: TextStyle(
                        color: Colors.purple)),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Text(
                      'No transactions yet!\nTap + to add one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      return Container(
                        margin:
                            EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: t.isIncome
                                    ? Colors.green
                                        .withOpacity(0.1)
                                    : Colors.red
                                        .withOpacity(
                                            0.1),
                                borderRadius:
                                    BorderRadius
                                        .circular(10),
                              ),
                              child: Icon(
                                t.isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: t.isIncome
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(t.title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight
                                              .w500)),
                            ),
                            Text(
                              t.isIncome
                                  ? '+₹${t.amount.toStringAsFixed(0)}'
                                  : '-₹${t.amount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                                color: t.isIncome
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.grey),
                              onPressed: () =>
                                  deleteTransaction(
                                      index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child:
            Icon(Icons.add, color: Colors.white),
        onPressed: showAddTransaction,
      ),
    );
  }
}
