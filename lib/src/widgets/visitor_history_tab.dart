import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/provider/visitor_provider.dart';
import 'package:loco_frontend/src/widgets/calendar.dart';
import 'package:loco_frontend/src/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'drop_down_field.dart';
import 'pop_up_window.dart';
import '../models/visitor.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class VisitorHistoryTab extends StatefulWidget {
  final String userType;
  const VisitorHistoryTab({super.key, required this.userType});

  @override
  State<VisitorHistoryTab> createState() => _VisitorHistoryTabState();
}

class _VisitorHistoryTabState extends State<VisitorHistoryTab> {
  final TextEditingController _searchTextController = TextEditingController();
  List<Visitor> filteredVisitors = [];
  DateTime? _selectedDate;
  String _selectedSearchCriteria = 'Name'; // Default search criteria

  // Define search criteria options
  final List<String> _searchCriteria = [
    'Name',
    'Phone',
    'Car Plate',
    'Resident ID', // This will only be shown for guards
  ];

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _searchTextController.text =
          DateFormat('dd/MM/yyyy').format(_selectedDate!);
      _filterVisitors(_searchTextController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VisitorProvider>(context, listen: false).fetchAllVisitors(
        userType: widget.userType,
      );
    });
  }

  void _filterVisitors(String query) {
    final visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);
    final allVisitors = visitorProvider.visitors;

    final searchQuery = query.toLowerCase();

    DateTime? stripTime(DateTime? dateTime) {
      return dateTime != null
          ? DateTime(dateTime.year, dateTime.month, dateTime.day)
          : null;
    }

    bool isDateQuery = false;
    DateTime? dateQuery;
    try {
      dateQuery = DateFormat('dd/MM/yyyy').parseStrict(query);
      isDateQuery = true;
    } catch (e) {
      isDateQuery = false;
    }

    setState(() {
      if (searchQuery.isEmpty) {
        filteredVisitors = allVisitors;
      } else {
        filteredVisitors = allVisitors.where((visitor) {
          if (isDateQuery) {
            final queryDate = stripTime(dateQuery!);
            return (visitor.checkInDate == queryDate) ||
                (visitor.checkOutDate == queryDate);
          }

          // Apply filter based on selected search criteria
          switch (_selectedSearchCriteria) {
            case 'Name':
              return visitor.fullName.toLowerCase().contains(searchQuery);
            case 'Phone':
              return visitor.hpNumber.toLowerCase().contains(searchQuery);
            case 'Car Plate':
              return visitor.carPlateNo.toLowerCase().contains(searchQuery);
            case 'Resident ID':
              return visitor.residentId
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery);
            default:
              return false;
          }
        }).toList();
      }
    });
  }

  // method for the header text
  String _getHeaderText(DateTime date) {
    final today = DateTime.now();
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));

    if (date.isAtSameMomentAs(today) ||
        date.isAfter(today.subtract(const Duration(days: 1)))) {
      return 'Today';
    } else if (date.isAfter(thisWeekStart)) {
      return 'This Week';
    } else if (date.year == today.year && date.month == today.month) {
      return 'This Month';
    } else if (date.year == today.year) {
      return DateFormat.MMMM().format(date); // Display the month name
    } else {
      return date.year
          .toString(); // Display the year if it's from last year or older
    }
  }

  // Modify the visitor card content to include resident info for guards
  Widget _buildVisitorCard(Visitor visitor, double containerHeight,
      double boxHeight, double boxWidth, double dateTimeWidth) {
    Widget card = Container(
      height: containerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: GlobalVariables.primaryColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  visitor.fullName,
                  style: GlobalVariables.bold20(context, GlobalVariables.white),
                ),
                if (widget.userType == 'guard')
                  Text(
                    'Resident ID: ${visitor.residentId}',
                    style: GlobalVariables.visitorHistoryDetail(context,
                        isBold: true),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: boxHeight,
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: Text(
                      'Checked-in',
                      style: GlobalVariables.visitorHistoryDetail(context),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: boxHeight,
                  width: dateTimeWidth,
                  decoration: BoxDecoration(
                    color: GlobalVariables.welcomeColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(visitor.checkInDate),
                        style: GlobalVariables.visitorHistoryDetail(context,
                            isBold: false),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        DateFormat('hh:mm a').format(visitor.checkInTime!),
                        style: GlobalVariables.visitorHistoryDetail(context,
                            isBold: false),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (visitor.checkOutDate != null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: boxHeight,
                    width: boxWidth,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Center(
                      child: Text(
                        'Checked-out',
                        style: GlobalVariables.visitorHistoryDetail(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: boxHeight,
                    width: dateTimeWidth,
                    decoration: BoxDecoration(
                      color: GlobalVariables.welcomeColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(visitor.checkOutDate!),
                          style: GlobalVariables.visitorHistoryDetail(context,
                              isBold: false),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          DateFormat('hh:mm a').format(visitor.checkOutTime!),
                          style: GlobalVariables.visitorHistoryDetail(context,
                              isBold: false),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ],
        ),
      ),
    );

    // Wrap with GestureDetector for residents
    if (widget.userType != 'guard') {
      return GestureDetector(
        onTap: () => _showVisitorDetails(visitor),
        child: card,
      );
    }

    // Wrap with Slidable for guards
    return GestureDetector(
      onTap: () => _showVisitorDetails(visitor),
      child: visitor.checkOutDate == null
          ? Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => _handleCheckOut(visitor),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.red,
                    icon: Icons.exit_to_app,
                    label: 'Check Out',
                  ),
                ],
              ),
              child: card,
            )
          : card, // If checkout time exists, just return the card without Slidable
    );
  }

  void _showVisitorDetails(Visitor visitor) {
    Popup(
      title: visitor.fullName,
      content: SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'Car Plate : ${visitor.carPlateNo}\n'
            'Phone       : ${visitor.hpNumber}\n'
            'Purpose   : ${visitor.purpose}\n'
            '${widget.userType == 'guard' ? 'Resident ID: ${visitor.residentId}\n' : ''}',
            textAlign: TextAlign.left,
          ),
        ),
      ),
      buttons: [
        ButtonConfig(text: 'Close', onPressed: () {}),
      ],
    ).show(context);
  }

  void _handleCheckOut(Visitor visitor) {
    Popup(
      title: 'Confirm Check Out',
      content: const SizedBox(
        height: 50,
        child: Center(
          child: Text('Are you sure you want to check out this visitor?'),
        ),
      ),
      buttons: [
        ButtonConfig(
          text: 'Cancel',
          onPressed: () {},
        ),
        ButtonConfig(
          text: 'Confirm',
          onPressed: () async {
            // Wait for checkout to complete
            await Provider.of<VisitorProvider>(context, listen: false)
                .checkOutVisitor(visitor.id);

            // Fetch updated visitor list
            if (mounted) {
              Provider.of<VisitorProvider>(context, listen: false)
                  .fetchAllVisitors(
                userType: widget.userType,
              );
            }
          },
        ),
      ],
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    // Filter search criteria based on user type
    final availableSearchCriteria = widget.userType == 'guard'
        ? _searchCriteria
        : _searchCriteria
            .where((criteria) => criteria != 'Resident ID')
            .toList();

    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Consumer<VisitorProvider>(
        builder: (context, visitorProvider, child) {
          if (visitorProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Get the filtered visitor list or the full visitor list
          final visitors =
              filteredVisitors.isEmpty && _searchTextController.text.isEmpty
                  ? visitorProvider.visitors
                  : filteredVisitors;

          print('Current filtered visitors: ${visitors.length}');

          // Filter visitors to show only those whose check-in or check-out dates are before today
          final today = DateTime.now();
          final pastVisitors = visitors.where((visitor) {
            DateTime? checkInDate = visitor.checkInDate;
            DateTime? checkOutDate = visitor.checkOutDate;
            DateTime? checkInTime = visitor.checkInTime;

            if (checkInTime != null) {
              final displayDate = checkOutDate ?? checkInDate;
              final todayStart = DateTime(today.year, today.month, today.day);

              // Include visitors with check-in/check-out date before or equal to today
              return !displayDate
                  .isAfter(todayStart); // This includes today's date
            }
            return false;
          }).toList();

          print('Past visitors: ${pastVisitors.map((v) => {
                'name': v.fullName,
                'checkIn': v.checkInDate,
                'checkOut': v.checkOutDate,
                'carPlate': v.carPlateNo
              })}');

          // Sort the visitors by their check-in or check-out date in descending order
          pastVisitors.sort((a, b) {
            DateTime aDate = a.checkOutDate ?? a.checkInDate;
            DateTime bDate = b.checkOutDate ?? b.checkInDate;
            return bDate.compareTo(aDate);
          });

          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;
          double containerHeight = screenHeight * 0.18;
          double boxHeight = screenHeight * 0.03;
          double boxWidth = screenWidth * 0.25;
          double dateTimeWidth = screenWidth * 0.45;

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.38,
                      child: MyDropdownField(
                        hint: 'Search by',
                        items: availableSearchCriteria,
                        value: _selectedSearchCriteria,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedSearchCriteria = newValue;
                              // Clear search when criteria changes
                              _searchTextController.clear();
                              _filterVisitors('');
                            });
                          }
                        },
                      ),
                    ),
                    // Search TextField
                    Expanded(
                      child: MyTextField(
                        controller: _searchTextController,
                        keyboardType: TextInputType.text,
                        hintText:
                            'Search by ${_selectedSearchCriteria.toLowerCase()}',
                        prefixIcon: Icons.search,
                        onChanged: _filterVisitors,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.date_range,
                        color: GlobalVariables.primaryColor,
                      ),
                      onPressed: () async {
                        DateTime? pickedDate = await showCalendar(
                          context,
                          minDate: DateTime(2022),
                          maxDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _onDateSelected(pickedDate);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.3),
                      ],
                      stops: [0.5, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: pastVisitors.isEmpty
                        ? Column(
                            children: [
                              Center(
                                child: Text(
                                  'No Results',
                                  style: GlobalVariables.noResultStyle(context),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: pastVisitors.length,
                            itemBuilder: (BuildContext context, int index) {
                              final visitor = pastVisitors[index];
                              final checkinDate = visitor.checkInDate;
                              final checkoutDate = visitor.checkOutDate;
                              final date = checkoutDate ?? checkinDate;
                              final headerText = _getHeaderText(date);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0 ||
                                      _getHeaderText(pastVisitors[index - 1]
                                                  .checkOutDate ??
                                              pastVisitors[index - 1]
                                                  .checkInDate) !=
                                          headerText)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        headerText,
                                        style: GlobalVariables
                                            .visitorHistoryTitleStyle(context),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 8.0),
                                    child: _buildVisitorCard(
                                        visitor,
                                        containerHeight,
                                        boxHeight,
                                        boxWidth,
                                        dateTimeWidth),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
