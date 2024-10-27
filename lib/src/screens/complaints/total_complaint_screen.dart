import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Complaint {
  final int id;
  final String title;
  final String description;
  final String status;
  final DateTime date;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });
}

class TotalComplaintScreen extends StatefulWidget {
  static const String routeName = '/total-complaint-screen';
  const TotalComplaintScreen({Key? key}) : super(key: key);

  @override
  State<TotalComplaintScreen> createState() => _TotalComplaintScreenState();
}

class _TotalComplaintScreenState extends State<TotalComplaintScreen> {
  String _selectedTimeFilter = 'All Time';
  final List<String> _timeFilters = ['All Time', 'This Week', 'This Month', 'This Year'];
  
  // Mock complaints data
  final List<Complaint> _allComplaints = [
    Complaint(
      id: 1,
      title: 'Product malfunction',
      description: 'Device stopped working after 2 days',
      status: 'In Progress',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Complaint(
      id: 2,
      title: 'Delivery delay',
      description: 'Package not received on time',
      status: 'Resolved',
      date: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Complaint(
      id: 3,
      title: 'Incorrect item',
      description: 'Received wrong product variant',
      status: 'Rejected',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    // Add more mock data as needed
  ];

  List<Complaint> get _filteredComplaints {
    final now = DateTime.now();
    return _allComplaints.where((complaint) {
      switch (_selectedTimeFilter) {
        case 'This Week':
          return now.difference(complaint.date).inDays <= 7;
        case 'This Month':
          return now.difference(complaint.date).inDays <= 30;
        case 'This Year':
          return now.difference(complaint.date).inDays <= 365;
        default:
          return true;
      }
    }).toList();
  }

  Map<String, int> get _statusCounts {
    final counts = {
      'Resolved': 0,
      'Rejected': 0,
      'In Progress': 0,
      'Total': 0,
    };
    
    for (var complaint in _filteredComplaints) {
      counts[complaint.status] = (counts[complaint.status] ?? 0) + 1;
      counts['Total'] = (counts['Total'] ?? 0) + 1;
    }
    
    return counts;
  }

  // Colors for different status types
  final Map<String, Color> _statusColors = {
    'Resolved': Colors.green,
    'Rejected': Colors.red,
    'In Progress': Colors.orange,
    'Total': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complaints Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Time filter dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  ..._statusCounts.entries.map((entry) => _buildStatCard(
                    title: entry.key,
                    count: entry.value,
                    color: _statusColors[entry.key]!,
                  )),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Complaints List
              Text(
                'Recent Complaints',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: _filteredComplaints.isEmpty
                    ? Center(
                        child: Text(
                          'No complaints found for selected period',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredComplaints.length,
                        itemBuilder: (context, index) {
                          final complaint = _filteredComplaints[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                complaint.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(complaint.description),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(complaint.date),
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColors[complaint.status]!.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  complaint.status,
                                  style: TextStyle(
                                    color: _statusColors[complaint.status],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
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