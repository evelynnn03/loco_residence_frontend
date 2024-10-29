import 'package:flutter/material.dart';
import '../constants/global_variables.dart';
import '../widgets/guard_list.dart';
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
                _buildGuardList(
                  data: [
                    {
                      'imageUrl': 'assets/images/guard1.jpg',
                      'name': 'John Doe',
                      'phoneNum': '+03 278 5673',
                    },
                    {
                      'imageUrl': 'assets/images/guard2.jpg',
                      'name': 'Jane Smith',
                      'phoneNum': '+03 488 3791',
                    },
                    {
                      'imageUrl': 'assets/images/guard3.jpg',
                      'name': 'Michael Johnson',
                      'phoneNum': '+03 521 8622',
                    },
                  ],
                ),
                _buildImportantItemsList(
                  data: [
                    {
                      'imageUrl': 'assets/images/police1.jpg',
                      'title': 'Puchong Jaya Police Station',
                      'phoneNum': '03-8947 1058',
                      'address':
                          'Jalan Kenari 11, Bandar Puchong Jaya, 47100 Puchong, Selangor, Malaysia',
                    },
                    {
                      'imageUrl': 'assets/images/police2.jpg',
                      'title': 'BALAI POLIS Bukit Puchong',
                      'phoneNum': '03-8949 0567',
                      'address':
                          '32, Jalan BPU 8, Bandar Puchong Utama, Puchong',
                    },
                    {
                      'imageUrl': 'assets/images/police3.jpeg',
                      'title': 'Bandar Kinrara Police Station',
                      'phoneNum': '03-8071 3136',
                      'address': 'Jalan Kinrara 5, Subang Jaya',
                    },
                  ],
                ),
                _buildImportantItemsList(
                  data: [
                    {
                      'imageUrl': 'assets/images/hospital1.jpg',
                      'title': 'Kuala Lumpur Hospital',
                      'phoneNum': '03-2615 5555',
                      'address': 'Jalan Pahang, Kuala Lumpur',
                    },
                    {
                      'imageUrl': 'assets/images/hospital2.jpg',
                      'title': 'Beacon Hospital',
                      'phoneNum': '03-7787 2992',
                      'address':
                          '1, Jalan 215, Section 51, Off Jalan Templer 46050 Petaling Jaya, Selangor',
                    },
                    {
                      'imageUrl': 'assets/images/hospital3.jpg',
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
                      'imageUrl': 'assets/images/fire1.jpg',
                      'title': 'Balai Bomba Dan Penyelamat Bandar Tun Razak',
                      'phoneNum': '03-9131 2440',
                      'address':
                          'Balai Bomba Dan Penyelamat Bandar Tun Razak Jalan Yaacob Latif 56000 Kuala Lumpur',
                    },
                    {
                      'imageUrl': 'assets/images/fire2.jpg',
                      'title': 'Balai Bomba Desa Sri Hartamas',
                      'phoneNum': '03-6203 2071',
                      'address':
                          'Jalan 23/70a, Desa Sri Hartamas 50480 Kuala Lumpur Kuala Lumpur',
                    },
                    {
                      'imageUrl': 'assets/images/fire3.jpg',
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

  Widget _buildGuardList({required List<Map<String, String>> data}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final guard = data[index];
          return GuardListItem(
            imageUrl: guard['imageUrl']!,
            name: guard['name']!,
            phoneNum: guard['phoneNum']!,
          );
        },
      ),
    );
  }
}
