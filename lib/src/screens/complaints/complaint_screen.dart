import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/screens/complaints/complaint_form.dart';
import 'package:loco_frontend/src/screens/complaints/total_complaint_screen.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../../provider/complaint_provider.dart';
import 'complaint_list_screen.dart';

class ComplaintScreen extends StatefulWidget {
  static const String routeName = '/complaint_screen';
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _totalComplaintsAnimation;
  late Animation<int> _thisWeekAnimation;
  late Animation<int> _thisMonthAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animations
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    final curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _totalComplaintsAnimation =
        IntTween(begin: 0, end: 0).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });

    _thisWeekAnimation = IntTween(begin: 0, end: 0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 1.0, curve: Curves.easeOut)),
    );

    _thisMonthAnimation = IntTween(begin: 0, end: 0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ComplaintProvider>(context, listen: false).fetchAllComplaints();
    });

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch the complaint list from Provider and calculate counts
    final complaintList = Provider.of<ComplaintProvider>(context).complaints;
    final counts = {
      'This Week': 0,
      'This Month': 0,
      'Total': complaintList.length,
    };

    for (final complaint in complaintList) {
      final now = DateTime.now();
      if (now.difference(complaint.date).inDays <= 7) {
        counts['This Week'] = counts['This Week']! + 1;
      }
      if (now.difference(complaint.date).inDays <= 30) {
        counts['This Month'] = counts['This Month']! + 1;
      }
    }

    // Update animations with new counts because this cant be done in initState
    // Provider.of<ComplaintProvider>(context) is being called in the initState method, which is too early in the widget lifecycle to depend on an inherited widget (like Provider
    _totalComplaintsAnimation =
        IntTween(begin: 0, end: counts['Total']).animate(_controller);
    _thisWeekAnimation = IntTween(begin: 0, end: counts['This Week']).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 1.0, curve: Curves.easeOut)),
    );
    _thisMonthAnimation = IntTween(begin: 0, end: counts['This Month']).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Count the number of complaints for each time filter

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Welcome back, Evelyn Tan',
                style: GlobalVariables.appbarStyle(context),
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
                        child: MyButton(
                          text: 'File a New Complaint',
                          onTap: () {
                            Navigator.pushNamed(
                                context, ComplaintForm.routeName);
                          },
                          iconData: Icons.add_circle_outline,
                        )

                        // Material(
                        //   color: Color(0xFF003878),
                        //   borderRadius: BorderRadius.circular(12),
                        //   child: InkWell(
                        //     borderRadius: BorderRadius.circular(12),
                        //     onTap: () {
                        //       Navigator.pushNamed(
                        //           context, ComplaintForm.routeName);
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(16),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(
                        //             Icons.add_circle_outline,
                        //             size: GlobalVariables.responsiveIconSize(
                        //                 context, 20.0),
                        //             color: Colors.white,
                        //           ),
                        //           SizedBox(width: 8),
                        //           Text(
                        //             'File a New Complaint',
                        //             style: GlobalVariables.bold16(
                        //               context,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        ),
                    const SizedBox(height: 10),
                    Text(
                      "Have an issue? We're here to help. Click above to start the process.",
                      style: GlobalVariables.helperStyle(context),
                      textAlign: TextAlign.center,
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
                style: GlobalVariables.bold20(
                  context,
                  GlobalVariables.primaryColor,
                ),
              ),
            ),

            // Statistics Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                return GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 3 : 1,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                  children: [
                    // Total Complaints Card
                    _buildStatCard(
                      onTap: () {
                        Navigator.pushNamed(
                            context, TotalComplaintScreen.routeName);
                      },
                      title: 'Total Complaints',
                      icon: Icons.description,
                      value: _totalComplaintsAnimation.value,
                      subtitle: 'All time',
                    ),
                    // This Week Card
                    _buildStatCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ComplainListScreen(
                              initialTimeFilter: 'This Week',
                            ),
                          ),
                        );
                      },
                      title: 'This Week',
                      icon: Icons.info_outline,
                      value: _thisWeekAnimation.value,
                      subtitle: 'Last 7 days',
                    ),
                    // This Month Card
                    _buildStatCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ComplainListScreen(
                              initialTimeFilter: 'This Month',
                            ),
                          ),
                        );
                      },
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
                    style: GlobalVariables.bold16(
                      context,
                      color: GlobalVariables.primaryGrey,
                    ),
                  ),
                  Icon(icon,
                      size: GlobalVariables.responsiveIconSize(context, 20),
                      color: GlobalVariables.primaryGrey),
                ],
              ),
              const Spacer(),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: GlobalVariables.responsiveFontSize(context, 35),
                  fontWeight: FontWeight.bold,
                  color: GlobalVariables.primaryColor,
                ),
              ),
              Text(
                subtitle,
                style: GlobalVariables.helperStyle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
