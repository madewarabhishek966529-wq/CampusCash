import 'package:campuscash/navbar.dart';
import 'package:campuscash/page/navigator%20page/analysis.dart';
import 'package:campuscash/page/navigator%20page/dashboard.dart';
import 'package:campuscash/page/navigator%20page/profile.dart';
import 'package:campuscash/page/navigator%20page/recordpage.dart';
import 'package:campuscash/page/navigator%20page/profilepage.dart/addexpense.dart';
import 'package:flutter/material.dart';

class WidgetPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const WidgetPage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<WidgetPage> createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: selectedPageNotifier,
        builder: (context, index, child) {
          switch (index) {
            case 0:
              return Dashboard(
                userName: widget.userName,
                userEmail: widget.userEmail,
              );
            case 1:
              return const Analysis();
            case 2:
              return const Addexpense();
            case 3:
              return const RecordPage();
            case 4:
              return Profile(
                userName: widget.userName,
                userEmail: widget.userEmail,
              );
            default:
              return const Center(child: Text("Invalid Page"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Addexpense()),
          );
        },
        backgroundColor: const Color(0xFF8B5CF6),
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const Navbar(),
    );
  }
}
