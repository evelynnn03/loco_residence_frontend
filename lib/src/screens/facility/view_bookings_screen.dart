import 'package:flutter/material.dart';
import 'package:loco_frontend/src/provider/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
          .fetchResidentBookings(); // Fetch all bookings
    });
  }

  _AppointmentDataSource _getCalendarDataSource() {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final residentBookings = bookingProvider.residentBookings;

    // Convert bookings to appointments
    List<Appointment> appointments = residentBookings.map((booking) {
      // Combine booking date with time to form a full DateTime string
      String startDateTimeString =
          '${booking.bookingDate} ${booking.startTime}';
      String endDateTimeString = '${booking.bookingDate} ${booking.endTime}';

      // Parse the combined strings into DateTime objects
      DateTime startTime = DateTime.parse(startDateTimeString);
      DateTime endTime = DateTime.parse(endDateTimeString);

      return Appointment(
        notes: booking.id.toString(), // Store booking ID in notes
        startTime: startTime,
        endTime: endTime,
        subject:
            'Booking #${booking.id}: ${booking.sectionId >= 1 && booking.sectionId <= 3 ? 'Pickle Ball Court' : 'Meeting Room'}',
        color: Colors.blue,
        startTimeZone: '',
        endTimeZone: '',
      );
    }).toList();

    // Add a sample appointment for testing
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(minutes: 10)),
      subject: 'Meeting',
      color: Colors.blue,
      startTimeZone: '',
      endTimeZone: '',
    ));

    return _AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<BookingProvider>(context).isLoading;
    // Method to show a confirmation dialog for canceling the appointment
    Future<void> _showCancelDialog(Appointment appointment) async {
      final bookingId = appointment.notes; // Retrieve booking ID from notes

      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancel Booking'),
            content: Text('Do you want to cancel Booking #$bookingId?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Confirm'),
                onPressed: () async {
                  // // Call your cancel booking method from the provider
                  final res =
                      await Provider.of<BookingProvider>(context, listen: false)
                          .cancelBooking(int.parse(bookingId!));
                  Navigator.of(context).pop();

                  // Show a Snackbar with the result message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res),
                      duration: Duration(seconds: 3), // Show for 3 seconds
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Container(
        child: SfCalendar(
          onTap: (calendarTapDetails) {
            if (calendarTapDetails.targetElement ==
                CalendarElement.appointment) {
              final appointment = calendarTapDetails.appointments![0];
              _showCancelDialog(appointment);
            }
          },
          view: CalendarView.schedule,
          scheduleViewSettings: ScheduleViewSettings(
              appointmentItemHeight: 70, hideEmptyScheduleWeek: true),
          dataSource: _getCalendarDataSource(),
        ),
      ),
    );
  }
}
