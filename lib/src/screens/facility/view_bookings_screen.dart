import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loco_frontend/src/provider/booking_provider.dart';
import 'package:loco_frontend/src/widgets/pop_up_window.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../constants/global_variables.dart';

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class ViewBookingsScreen extends StatefulWidget {
  const ViewBookingsScreen({super.key});
  static const String routeName = '/view_booking_screen';

  @override
  State<ViewBookingsScreen> createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false)
          .fetchResidentBookings();
    });
  }

  _AppointmentDataSource _getCalendarDataSource() {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final residentBookings = bookingProvider.residentBookings;
    final now = DateTime.now();

    // Convert bookings to appointments, filtering out past bookings
    List<Appointment> appointments = residentBookings
        .map((booking) {
          String startDateTimeString =
              '${booking.bookingDate} ${booking.startTime}';
          String endDateTimeString =
              '${booking.bookingDate} ${booking.endTime}';

          DateTime startTime = DateTime.parse(startDateTimeString);
          DateTime endTime = DateTime.parse(endDateTimeString);

          // Skip this booking if it's in the past
          if (endTime.isBefore(now)) {
            return null;
          }

          final DateFormat timeFormatter = DateFormat('h:mm a');
          final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');
          String facilityName =
              (booking.sectionId >= 1 && booking.sectionId <= 3)
                  ? 'Pickle Ball Court ${booking.sectionId}'
                  : 'Meeting Room ${booking.sectionId}';

          return Appointment(
            notes:
                'Booking ID: ${booking.id}\n$facilityName\nDate: ${dateFormatter.format(DateTime.parse(booking.bookingDate))}\nTime: ${timeFormatter.format(startTime)} - ${timeFormatter.format(endTime)}',
            startTime: startTime,
            endTime: endTime,
            subject: facilityName,
            color: const Color.fromARGB(255, 162, 213, 255),
            startTimeZone: '',
            endTimeZone: '',
          );
        })
        .where((appointment) =>
            appointment != null) // Filter out null appointments
        .cast<Appointment>() // Cast the filtered list to List<Appointment>
        .toList();

    return _AppointmentDataSource(appointments);
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final Appointment appointment = details.appointments.first;
    final String subject = appointment.subject.toLowerCase();

    Color appointmentColor;
    if (subject.contains('pickle ball')) {
      appointmentColor = const Color.fromARGB(255, 255, 218, 137);
    } else if (subject.contains('meeting')) {
      appointmentColor = const Color.fromARGB(255, 159, 199, 255);
    } else {
      appointmentColor = const Color.fromARGB(255, 222, 186, 255);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: appointmentColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.subject,
            style: GlobalVariables.bold16(context, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            '${DateFormat('h:mm a').format(appointment.startTime)} - ${DateFormat('h:mm a').format(appointment.endTime)}',
            style: GlobalVariables.bold16(context,
                color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }

  Widget scheduleViewHeaderBuilder(
      BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
    final String monthName = _getMonthName(details.date.month).toLowerCase();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/$monthName.jpeg',
              fit: BoxFit.cover,
              width: details.bounds.width,
              height: details.bounds.height,
            ),
            Container(
              width: details.bounds.width,
              height: details.bounds.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                '$monthName ${details.date.year}'.toUpperCase(),
                style: GlobalVariables.bold20(context, Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<BookingProvider>(context).isLoading;

    Future<void> showCancelDialog(Appointment appointment) async {
      final bookingDetails = appointment.notes;
      String notes = bookingDetails ?? '';
      final facilityDetails = notes.split('\n').skip(1).join('\n');

      return Popup(
        title: 'Cancel Booking',
        content: Text(
          facilityDetails,
          style: GlobalVariables.bold16(context,
              color: GlobalVariables.primaryColor),
        ),
        buttons: [
          ButtonConfig(
            text: 'Confirm',
            onPressed: () async {
              try {
                final parts = notes.split('\n');
                String bookingIdStr = '';

                for (var part in parts) {
                  if (part.startsWith('Booking ID:')) {
                    bookingIdStr = part.split(':').last.trim();
                    break;
                  }
                }

                final bookingId = int.parse(bookingIdStr);

                // Get the BookingProvider
                final bookingProvider =
                    Provider.of<BookingProvider>(context, listen: false);

                // Cancel the booking
                final res = await bookingProvider.cancelBooking(bookingId);

                // Close the dialog
                Navigator.of(context).pop;

                // Refresh the bookings
                await bookingProvider.fetchResidentBookings();

                // Show success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              } catch (e) {
                print('Error parsing booking ID: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Failed to cancel booking. Please try again.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
          ),
          ButtonConfig(
              text: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop;
              })
        ],
      ).show(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.secondaryColor,
        title: Text(
          'Bookings',
          style: GlobalVariables.appbarStyle(context,
              color: GlobalVariables.primaryColor),
        ),
        leading: GlobalVariables.backButton(context,
            color: GlobalVariables.primaryColor),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCalendar(
                headerHeight: 0,
                todayHighlightColor: const Color.fromARGB(255, 255, 162, 156),
                onTap: (calendarTapDetails) {
                  if (calendarTapDetails.targetElement ==
                      CalendarElement.appointment) {
                    final appointment = calendarTapDetails.appointments![0];
                    showCancelDialog(appointment);
                  }
                },
                view: CalendarView.schedule,
                scheduleViewSettings: ScheduleViewSettings(
                  appointmentItemHeight: 80,
                  hideEmptyScheduleWeek: true,
                  dayHeaderSettings: DayHeaderSettings(
                    width: 70,
                    dayTextStyle: TextStyle(
                      fontSize: GlobalVariables.responsiveFontSize(context, 13),
                      color: GlobalVariables.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    dateTextStyle: GlobalVariables.bold20(
                        context, GlobalVariables.primaryColor),
                  ),
                  weekHeaderSettings: const WeekHeaderSettings(height: 0),
                  monthHeaderSettings: MonthHeaderSettings(
                    height: MediaQuery.of(context).size.height * 0.15,
                    textAlign: TextAlign.center,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                dataSource: _getCalendarDataSource(),
                appointmentBuilder: appointmentBuilder,
                scheduleViewMonthHeaderBuilder: scheduleViewHeaderBuilder,
              ),
            ),
    );
  }
}
