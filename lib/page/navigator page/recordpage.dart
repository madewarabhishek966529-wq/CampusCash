import 'package:campuscash/page/databse/databs.dart';
import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});
  @override
  State<RecordPage> createState() => _RecordState();
}

class _RecordState extends State<RecordPage> {
  final DatabaseService db = DatabaseService.instance;

  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final exp = await db.getExpenses();
    if (mounted) {
      setState(() {
        expenses = exp;
      });
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "food":
        return Icons.restaurant;
      case "transport":
        return Icons.directions_car;
      case "rent":
        return Icons.home;
      case "study":
        return Icons.school;
      case "shopping":
        return Icons.shopping_bag;
      case "entertainment":
        return Icons.movie;
      case "medical":
        return Icons.local_hospital;
      default:
        return Icons.category;
    }
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "food":
        return Colors.orange;
      case "transport":
        return Colors.blue;
      case "rent":
        return Colors.green;
      case "shopping":
        return Colors.purple;
      case "study":
        return Colors.indigo;
      case "entertainment":
        return Colors.pink;
      case "medical":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Deep dark background
      appBar: AppBar(
        titleSpacing: 24,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "All Records",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: expenses.isEmpty
          ? Center(
              child: Text(
                "No records found.",
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final item = expenses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E35),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          getCategoryIcon(item["category"]),
                          color: getCategoryColor(item["category"]),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${item["title"]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${item["category"]} • ${item["date"]}",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "-₹${item["amount"]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: const Color(0xFF1E1E35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text(
                                      "Delete expense?",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: const Text(
                                      "This cannot be undone.",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await db.deleteExpense(item["id"]);
                                          loadData();
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
