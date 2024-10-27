import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/screens/complaints/total_complaint_screen.dart';

class ComplaintScreen extends StatefulWidget {
  static const String routeName = '/complaint_screen';
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _totalComplaintsAnimation;
  late Animation<int> _thisWeekAnimation;
  late Animation<int> _thisMonthAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    // Curved animation for a smooth, accelerating effect
    final curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Setting up animations for each number
    _totalComplaintsAnimation = IntTween(begin: 0, end: 10).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    _thisWeekAnimation = IntTween(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _thisMonthAnimation = IntTween(begin: 0, end: 3).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Welcome back, Evelyn Tan',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: MediaQuery.of(context).size.width > 600 
                    ? TextAlign.left 
                    : TextAlign.center,
              ),
            ),

            // File Complaint Card
            Card(
              margin: const EdgeInsets.only(bottom: 24.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width > 600 
                          ? 200 
                          : double.infinity,
                      height: 56,
                      child: Material(
                        color: Color(0xFF003878),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'File a New Complaint',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Have an issue? We're here to help. Click above to start the process.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Statistics Header
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Complaint Statistics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Statistics Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                return GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                  children: [
                    // Total Complaints Card
                    _buildStatCard(
                      onTap: () {
                        Navigator.pushNamed(context, TotalComplaintScreen.routeName);
                      },
                      title: 'Total Complaints',
                      icon: Icons.description,
                      value: _totalComplaintsAnimation.value,
                      subtitle: 'All time',
                    ),
                    // This Week Card
                    _buildStatCard(
                      title: 'This Week',
                      icon: Icons.info_outline,
                      value: _thisWeekAnimation.value,
                      subtitle: 'Last 7 days',
                    ),
                    // This Month Card
                    _buildStatCard(
                      title: 'This Month',
                      icon: Icons.info_outline,
                      value: _thisMonthAnimation.value,
                      subtitle: 'Last 30 days',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create each stat card
  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required int value,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(icon, size: 16, color: Colors.grey[600]),
                ],
              ),
              const Spacer(),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                  color: GlobalVariables.primaryColor,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
