import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class VisitorHistoryTab extends StatefulWidget {
  const VisitorHistoryTab({super.key});

  @override
  State<VisitorHistoryTab> createState() => _VisitorHistoryTabState();
}

class _VisitorHistoryTabState extends State<VisitorHistoryTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Text('Visitor History'),
    );
  }
}

