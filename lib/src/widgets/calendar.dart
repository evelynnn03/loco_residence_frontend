import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../constants/global_variables.dart';

// This function shows the calendar as a dialog with action buttons
Future<DateTime?> showCalendar(
  BuildContext context, {
  required DateTime minDate,
  DateTime? maxDate,
  bool maxDateEndOfYear = false,
}) async {
  DateTime? selectedDate;
  return await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: CalendarWidget(
          minDate: minDate,
          maxDate: maxDate,
          maxDateEndOfYear: maxDateEndOfYear,
          showActionButtons: true,
          onDateSelected: (date) {
            selectedDate = date;
          },
          onSubmit: () {
            Navigator.of(context).pop(selectedDate);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      );
    },
  );
}

class CalendarWidget extends StatefulWidget {
  final DateTime minDate;
  final DateTime? maxDate;
  final bool maxDateEndOfYear;
  final Function(DateTime) onDateSelected;
  final bool showActionButtons;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final bool showNavigationArrow;
  final bool isDialog;

  const CalendarWidget({
    Key? key,
    required this.minDate,
    this.maxDate,
    this.maxDateEndOfYear = false,
    required this.onDateSelected,
    this.showActionButtons = false,
    this.onSubmit,
    this.onCancel,
    this.showNavigationArrow = true,
    this.isDialog = true,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final DateTime effectiveMaxDate = widget.maxDateEndOfYear
        ? DateTime(DateTime.now().year, 12, 31)
        : widget.maxDate ?? DateTime(DateTime.now().year, 12, 31);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: widget.isDialog
            ? GlobalVariables.secondaryColor
            : GlobalVariables.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfDateRangePicker(
          initialSelectedDate: DateTime.now(),
          minDate: widget.minDate,
          maxDate: effectiveMaxDate,
          todayHighlightColor: Colors.transparent,
          backgroundColor: widget.isDialog
              ? GlobalVariables.secondaryColor
              : GlobalVariables.primaryColor,
          selectionColor: widget.isDialog
              ? GlobalVariables.primaryColor
              : GlobalVariables.secondaryColor,
          selectionTextStyle: TextStyle(
            color: widget.isDialog
                ? GlobalVariables.white
                : GlobalVariables.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          monthViewSettings: DateRangePickerMonthViewSettings(
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: TextStyle(
                color: widget.isDialog ? Colors.black : Colors.white,
              ),
            ),
          ),
          monthCellStyle: DateRangePickerMonthCellStyle(
            textStyle: TextStyle(
              color: widget.isDialog ? Colors.black : Colors.white,
            ),
            disabledDatesTextStyle: TextStyle(
              color: widget.isDialog ? Colors.grey : Colors.white24,
            ),
            todayTextStyle: TextStyle(
              color: widget.isDialog ? Colors.black : Colors.white,
            ),
          ),
          yearCellStyle: DateRangePickerYearCellStyle(
            disabledDatesTextStyle: TextStyle(
                color: widget.isDialog ? Colors.grey : Colors.white24),
          ),
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: widget.isDialog
                ? GlobalVariables.secondaryColor
                : GlobalVariables.primaryColor,
            textStyle: TextStyle(
              color: widget.isDialog
                  ? GlobalVariables.primaryColor
                  : GlobalVariables.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          headerHeight: 60,
          showNavigationArrow: widget.showNavigationArrow,
          showActionButtons: widget.showActionButtons,
          onCancel: widget.onCancel,
          onSubmit: (_) {
            if (_selectedDate != null) {
              widget.onDateSelected(_selectedDate!);
            }
            if (widget.onSubmit != null) {
              widget.onSubmit!();
            }
          },
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value is DateTime) {
              setState(() {
                _selectedDate = args.value;
              });
              widget.onDateSelected(_selectedDate!);
            }
          },
        ),
      ),
    );
  }
}
