import 'package:flutter/material.dart';

import '../constants/global_variables.dart';
import '../utils/read data/guard_details.dart';
import '../widgets/important_items.dart';

class ImportantContactScreen extends StatefulWidget {
  const ImportantContactScreen({super.key});
  static const String routeName = '/important_contact';

  @override
  _ImportantContactScreenState createState() => _ImportantContactScreenState();
}

class _ImportantContactScreenState extends State<ImportantContactScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Color? iconColor = Theme.of(context).indicatorColor;

    return Scaffold(
        backgroundColor: GlobalVariables.secondaryColor,
        appBar: AppBar(
          backgroundColor: GlobalVariables.secondaryColor,
          title: Text(
            'Important Contacts',
            style: GlobalVariables.appbarStyle(context),
          ),
          leading: GlobalVariables.backButton(context),
        ),
        body: Column(
          children: [
            TabBar(
              tabAlignment: TabAlignment.center,
              controller: _tabController,
              isScrollable: true,
              labelColor: GlobalVariables.primaryColor,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              unselectedLabelColor: GlobalVariables.primaryGrey,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(
                  child: Text(
                    'Guards',
                  ),
                ),
                Tab(
                  child: Text(
                    'Police',
                  ),
                ),
                Tab(
                  child: Text(
                    'Hospital',
                  ),
                ),
                Tab(
                  child: Text(
                    'Firefighter',
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                const Column(
                  // children: [
                  //   Expanded(
                  //     child: GuardDetails(
                  //       showImage: true,
                  //       hasSlidable: false,
                  //     ),
                  //   ),
                  // ],
                ),
                _buildImportantItemsList(
                  data: [
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/police1.jpg?alt=media&token=9dea3788-5114-4399-8c41-2d193f65d4e7',
                      'title': 'Puchong Jaya Police Station',
                      'phoneNum': '03-8947 1058',
                      'address':
                          'Jalan Kenari 11, Bandar Puchong Jaya, 47100 Puchong, Selangor, Malaysia',
                    },
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/police2.jpg?alt=media&token=63b9caa7-10d4-4fc1-8fb0-e58642b13109',
                      'title': 'BALAI POLIS Bukit Puchong',
                      'phoneNum': '03-8949 0567',
                      'address':
                          '32, Jalan BPU 8, Bandar Puchong Utama, Puchong',
                    },
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/police3.jfif?alt=media&token=53061333-dea4-4715-bea5-84da4289bf00',
                      'title': 'Bandar Kinrara Police Station',
                      'phoneNum': '03-8071 3136',
                      'address': 'Jalan Kinrara 5, Subang Jaya',
                    },
                  ],
                ),
                _buildImportantItemsList(
                  data: [
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/hospital1.jpg?alt=media&token=3a2b3953-b7fc-411e-ac47-ec46fe2e5fe8',
                      'title': 'Kuala Lumpur Hospital',
                      'phoneNum': '03-2615 5555',
                      'address': 'Jalan Pahang, Kuala Lumpur',
                    },
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/hospital2.jpg?alt=media&token=40212d02-12f1-4253-8fb7-2c3b23a50aed',
                      'title': 'Beacon Hospital',
                      'phoneNum': '03-7787 2992',
                      'address':
                          '1, Jalan 215, Section 51, Off Jalan Templer 46050 Petaling Jaya, Selangor',
                    },
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/hospital3.jpg?alt=media&token=eeb23f48-0b8e-4b2e-9548-2678ae7a80e3',
                      'title': 'Sunway Medical Centre',
                      'phoneNum': '03-7491 9191',
                      'address':
                          'No 5, Jalan Lagoon Selatan, Bandar Sunway 47500 Subang Jaya Selangor',
                    },
                  ],
                ),
                _buildImportantItemsList(
                  data: [
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/fire1.jpg?alt=media&token=e3ea6175-207b-4dee-8678-b60463437b6b',
                      'title': 'Balai Bomba Dan Penyelamat Bandar Tun Razak',
                      'phoneNum': '03-9131 2440',
                      'address':
                          'Balai Bomba Dan Penyelamat Bandar Tun Razak Jalan Yaacob Latif 56000 Kuala Lumpur',
                    },
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/fire2.jpg?alt=media&token=b63f04ff-7528-472c-8b56-0f6290900190',
                      'title': 'Balai Bomba Desa Sri Hartamas',
                      'phoneNum': '03-6203 2071',
                      'address':
                          'Jalan 23/70a, Desa Sri Hartamas 50480 Kuala Lumpur Kuala Lumpur',
                    },
                    {
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/fire3.jpg?alt=media&token=0c76e4dc-b423-4eb9-8cfb-6635ab303886',
                      'title': 'Balai Bomba Keramat Jalan Jelatek',
                      'phoneNum': '03-4251 4863',
                      'address':
                          'Jalan Jelatek 54200 Kuala Lumpur Federal Territory of Kuala Lumpur',
                    },
                  ],
                ),
              ]),
            ),
          ],
        ));
  }

  Widget _buildImportantItemsList({required List<Map<String, String>> data}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ImportantItems(
                imageUrl: data[index]['imageUrl']!,
                title: data[index]['title']!,
                phoneNum: data[index]['phoneNum']!,
                address: data[index]['address']!,
              ),
            ],
          );
        },
      ),
    );
  }
}
