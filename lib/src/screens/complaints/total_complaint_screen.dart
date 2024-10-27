import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:loco_frontend/src/provider/complaint_provider.dart';
import '../../models/complaint.dart';
import '../../utils/complaint_utils.dart';

class TotalComplaintScreen extends StatefulWidget {
  static const String routeName = '/total-complaint-screen';
  const TotalComplaintScreen({Key? key}) : super(key: key);

  @override
  State<TotalComplaintScreen> createState() => _TotalComplaintScreenState();
}

class _TotalComplaintScreenState extends State<TotalComplaintScreen> {
  String _selectedTimeFilter = 'All Time';
  final List<String> _timeFilters = [
    'All Time',
    'This Week',
    'This Month',
    'This Year'
  ];
  bool _isListExpanded = false;
  // Updated status colors to match Django model's STATUS_CHOICES
  static const Map<String, Color> _statusColors = {
    'Received': Colors.blue, // Blue for new complaints
    'In Progress': Colors.orange, // Orange for ongoing
    'Resolved': Colors.green, // Green for success
    'Rejected': Colors.red, // Red for rejected
    'Total': Colors.indigo, // Different blue for total to distinguish
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ComplaintProvider>(context, listen: false).fetchComplaints();
    });
  }

  void _toggleListView() {
    setState(() {
      _isListExpanded = !_isListExpanded;
    });
  }



  Map<String, int> getStatusCounts(List<Complaint> complaints) {
    // Initialize counts with all possible statuses from Django model
    final counts = {
      'Received': 0,
      'In Progress': 0,
      'Resolved': 0,
      'Rejected': 0,
      'Total': complaints.length,
    };

    for (var complaint in complaints) {
      // Since we know the status will be one of our defined choices, we can safely increment
      counts[complaint.status] = (counts[complaint.status] ?? 0) + 1;
    }

    return counts;
  }

  String getStatusDisplayText(String status) {
    // Optional: Format status text for display if needed
    return status;
  }

  Color getStatusColor(String status) {
    return _statusColors[status] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Consumer<ComplaintProvider>(
          builder: (context, complaintProvider, _) {
            final allComplaints = complaintProvider.complaints;
            final filteredComplaints =
                filterComplaints(allComplaints, _selectedTimeFilter);
            final statusCounts = getStatusCounts(filteredComplaints);

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isListExpanded
                      ? kToolbarHeight // Just enough height for the collapse button
                      : MediaQuery.of(context).size.height * 0.6,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!_isListExpanded) ...[
                            Text(
                              'Complaints Overview',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),

                            // Time filter dropdown
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedTimeFilter,
                                  isExpanded: true,
                                  items: _timeFilters.map((String filter) {
                                    return DropdownMenuItem<String>(
                                      value: filter,
                                      child: Text(filter),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _selectedTimeFilter = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Stats grid
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.5,
                                children: statusCounts.entries
                                    .map((entry) => _buildStatCard(
                                          title: entry.key,
                                          count: entry.value,
                                          color: getStatusColor(entry.key),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Complaints List Section
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Complaints',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextButton.icon(
                              onPressed: _toggleListView,
                              icon: Icon(
                                _isListExpanded ? Icons.compress : Icons.expand,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                              label: Text(
                                _isListExpanded ? 'Collapse' : 'View All',
                                style: TextStyle(
                                  color: GlobalVariables.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Complaints List
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
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                getStatusColor(complaint.status)
                                                    .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            complaint.status,
                                            style: TextStyle(
                                              color: getStatusColor(
                                                  complaint.status),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Icon(
                Icons.trending_up,
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
