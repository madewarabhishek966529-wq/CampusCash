import 'package:campuscash/page/databse/databs.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});
  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  final DatabaseService db = DatabaseService.instance;

  List<Map<String, dynamic>> expenses = [];
  Map<String, double> categoryTotals = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  final List<Color> colors = [
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFFF43F5E), // Rose
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFFF59E0B), // Amber
    const Color(0xFF10B981), // Emerald
    const Color(0xFF3B82F6), // Blue
    const Color(0xFFD946EF), // Fuchsia
  ];

  Future<void> loadData() async {
    try {
      final data = await db.getExpenses();
      Map<String, double> temp = {};
      for (var item in data) {
        String category = item['category'].toString();
        double amount = double.tryParse(item['amount'].toString()) ?? 0;
        if (amount > 0) {
          temp[category] = (temp[category] ?? 0) + amount;
        }
      }
      if (mounted) {
        setState(() {
          expenses = data;
          categoryTotals = temp;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading analysis data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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

  double get totalSpending =>
      categoryTotals.values.fold(0, (sum, value) => sum + value);

  List<PieChartSectionData> buildSections() {
    int index = 0;
    return categoryTotals.entries.map((e) {
      final section = PieChartSectionData(
        value: e.value,
        title: e.value.toStringAsFixed(0),
        radius: 80,
        color: colors[index % colors.length],
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
      index++;
      return section;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Deep dark background
      appBar: AppBar(
        titleSpacing: 24,
        title: const Text(
          "Statistics",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
              )
            : categoryTotals.isEmpty
            ? Center(
                child: Text(
                  "No expense data",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 240,
                    child: PieChart(
                      PieChartData(
                        sections: buildSections(),
                        centerSpaceRadius: 50,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Spending By Category",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: categoryTotals.entries.length,
                      itemBuilder: (context, index) {
                        var entry = categoryTotals.entries.elementAt(index);
                        String title = entry.key;
                        double amount = entry.value;
                        double percent = amount / totalSpending;
                        Color displayColor = colors[index % colors.length];

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
                                  color: displayColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  getCategoryIcon(title),
                                  color: displayColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: percent,
                                        minHeight: 6,
                                        backgroundColor: Colors.white12,
                                        valueColor: AlwaysStoppedAnimation(
                                          displayColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹${amount.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${(percent * 100).toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
