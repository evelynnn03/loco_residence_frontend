import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:loco_frontend/src/provider/complaint_provider.dart';
import '../../models/complaint.dart';
import '../../utils/complaint_utils.dart';

class ComplainListScreen extends StatefulWidget {
  static const String routeName = '/total-complaint-screen';
  final String initialTimeFilter;

  const ComplainListScreen({
    Key? key,
    this.initialTimeFilter = 'All Time', // Default value if none is provided
  }) : super(key: key);

  @override
  State<ComplainListScreen> createState() => _ComplainListScreenState();
}

class _ComplainListScreenState extends State<ComplainListScreen> {
  late String
      _selectedTimeFilter; // Store the selected filter for displaying complaints

  // Updated status colors to match Django model's STATUS_CHOICES
  static const Map<String, Color> _statusColors = {
    'Received': Colors.blue,
    'In Progress': Colors.orange,
    'Resolved': Colors.green,
    'Rejected': Colors.red,
    'Total': Colors.indigo,
  };

  @override
  void initState() {
    super.initState();

    // Use the initial time filter from the widget
    _selectedTimeFilter = widget.initialTimeFilter;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ComplaintProvider>(context, listen: false).fetchComplaints();
    });
  }

  Color getStatusColor(String status) {
    return _statusColors[status] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Complaints for: $_selectedTimeFilter',
          style: GlobalVariables.appbarStyle(context),
        ),
      ),
      body: SafeArea(
        child: Consumer<ComplaintProvider>(
          builder: (context, complaintProvider, _) {
            final allComplaints = complaintProvider.complaints;
            final filteredComplaints =
                filterComplaints(allComplaints, _selectedTimeFilter);

            return Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Complaints for: $_selectedTimeFilter',
                //     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                //           fontWeight: FontWeight.bold,
                //         ),
                //   ),
                // ),

                // Complaints List Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: filteredComplaints.isEmpty
                        ? Center(
                            child: Text(
                              'No complaints found for selected period',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredComplaints.length,
                            itemBuilder: (context, index) {
                              final complaint = filteredComplaints[index];
                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  title: Text(
                                    complaint.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(complaint.description),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('MMM dd, yyyy')
                                            .format(complaint.date),
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(complaint.status)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      complaint.status,
                                      style: TextStyle(
                                        color: getStatusColor(complaint.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
