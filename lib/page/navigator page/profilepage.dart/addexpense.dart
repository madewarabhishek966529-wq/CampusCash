import 'package:campuscash/navbar.dart';
import 'package:campuscash/page/databse/databs.dart';
import 'package:flutter/material.dart';

class Addexpense extends StatefulWidget {
  const Addexpense({super.key});
  @override
  State<Addexpense> createState() => _AddexpenseState();
}

class _AddexpenseState extends State<Addexpense> {
  final DatabaseService db = DatabaseService.instance;
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  int selectedIndex = 0;
  final categories = [
    {"name": "Food", "icon": Icons.restaurant, "color": Colors.orange},
    {"name": "Transport", "icon": Icons.directions_car, "color": Colors.blue},
    {"name": "Rent", "icon": Icons.home, "color": Colors.green},
    {"name": "Shopping", "icon": Icons.shopping_bag, "color": Colors.purple},
    {"name": "Study", "icon": Icons.school, "color": Colors.indigo},
    {"name": "Entertainment", "icon": Icons.movie, "color": Colors.pink},
    {"name": "Medical", "icon": Icons.local_hospital, "color": Colors.red},
    {"name": "Other", "icon": Icons.category, "color": Colors.grey},
  ];

  String? category;

  @override
  void initState() {
    super.initState();
    category = categories[0]["name"] as String;
  }

  Future<void> pickDate() async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF8B5CF6),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E35),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (d != null) {
      setState(() {
        dateController.text =
            "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void addExpense() async {
    if (amountController.text.isEmpty ||
        titleController.text.isEmpty ||
        category == null ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      final amount = double.parse(amountController.text.trim());

      await db.addExpense(
        amount,
        titleController.text.trim(),
        category!,
        dateController.text.trim(),
      );

      if (!mounted) return;

      // Clear inputs
      amountController.clear();
      titleController.clear();
      dateController.clear();

      // Switch dashboard tab
      selectedPageNotifier.value = 0;

      // CLOSE AddExpense page and go back to dashboard
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding expense: $e')));

      debugPrint('Error inserting to DB: $e');
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Deep dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 10,
        title: const Text(
          "Add Expense",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Amount Input Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: "0",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixText: "₹ ",
                      prefixStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Title Field
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Title",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "What did you spend on?",
                  hintStyle: TextStyle(color: Colors.white30),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date Selection
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      dateController.text.isEmpty
                          ? "Select Date"
                          : dateController.text,
                      style: TextStyle(
                        color: dateController.text.isEmpty
                            ? Colors.white30
                            : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category Selection
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Category",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                bool isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      category = categories[index]["name"] as String;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFF1E1E35),
                          shape: BoxShape.circle,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8B5CF6,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                          border: isSelected
                              ? null
                              : Border.all(color: Colors.white12),
                        ),
                        child: Icon(
                          categories[index]["icon"] as IconData,
                          color: isSelected
                              ? Colors.white
                              : (categories[index]["color"] as Color),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categories[index]["name"] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.white54,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                ),
                onPressed: addExpense,
                child: const Text(
                  "Save Expense",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
