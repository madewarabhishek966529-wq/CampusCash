import 'package:campuscash/page/databse/databs.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Dashboard extends StatefulWidget {
  final String userName;
  final String userEmail;
  const Dashboard({super.key, this.userName = "User", this.userEmail = ''});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseService db = DatabaseService.instance;

  List<Map<String, dynamic>> expenses = [];
  double total = 0;
  double monthlyBudget = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final exp = await db.getExpenses();
    final tot = await db.getTotal();
    final budget = await db.getMonthlyBudget();
    if (mounted) {
      setState(() {
        expenses = exp;
        total = tot;
        monthlyBudget = budget;
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

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    }
    if (hour < 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }

  void _showSetBudgetDialog() {
    final TextEditingController budgetCtrl = TextEditingController(
      text: monthlyBudget > 0 ? monthlyBudget.toStringAsFixed(0) : '',
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Set Monthly Budget',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: budgetCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. 5000',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixText: '₹ ',
              prefixStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final val = double.tryParse(budgetCtrl.text.trim());
                if (val != null && val >= 0) {
                  await db.setMonthlyBudget(val);
                  loadData();
                  if (context.mounted) Navigator.pop(context);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number for budget'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverBudget = (monthlyBudget > 0 && total > monthlyBudget);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Deep dark background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreeting(),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.userEmail.isNotEmpty)
                  Text(
                    widget.userEmail,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.grey[400]),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Spent",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "₹${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Monthly Budget",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: _showSetBudgetDialog,
                          child: const Icon(
                            Icons.edit_note_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      monthlyBudget > 0
                          ? "₹${monthlyBudget.toStringAsFixed(0)}"
                          : "Not Set",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          monthlyBudget > 0
                              ? "Remaining: ₹${(monthlyBudget - total).toStringAsFixed(0)}"
                              : "Tap edit to set budget",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                        const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ],
                    ),
                    if (monthlyBudget > 0) ...[
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (total / monthlyBudget).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isOverBudget ? Colors.redAccent : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (isOverBudget)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Warning: You have exceeded your monthly budget by ₹${(total - monthlyBudget).toStringAsFixed(0)}!",
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (expenses.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Lottie.asset(
                        'assets/lotties/money.json',
                        width: 150,
                        repeat: false,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No expenses yet",
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenses.length > 5 ? 5 : expenses.length,
                  itemBuilder: (context, index) {
                    final item = expenses[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E35),
                        borderRadius: BorderRadius.circular(16),
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
                              size: 20,
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${item["category"]} • ${item["date"]}",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "-₹${item["amount"]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
