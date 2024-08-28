import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../constants/global_variables.dart';

Future<DateTime?> showCalendar(BuildContext context,
    {required DateTime minDate, DateTime? maxDate}) async {
  DateTime? selectedDate;
  return await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
              color: GlobalVariables.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SfDateRangePicker(
              minDate: minDate,
              maxDate: maxDate,
              todayHighlightColor: Colors.transparent,
              backgroundColor: GlobalVariables.secondaryColor,
              selectionColor: GlobalVariables.primaryColor,
              selectionTextStyle: const TextStyle(
                color: GlobalVariables.white,
                fontWeight: FontWeight.bold,
              ),
              monthCellStyle: const DateRangePickerMonthCellStyle(
                disabledDatesTextStyle: TextStyle(color: Colors.grey),
              ),
              yearCellStyle: const DateRangePickerYearCellStyle(
                disabledDatesTextStyle: TextStyle(color: Colors.grey),
              ),
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: GlobalVariables.secondaryColor,
                textStyle: GlobalVariables.notifTitleStyle(context),
              ),
              showNavigationArrow: true,
              showActionButtons: true,
              onCancel: () => Navigator.of(context).pop(),
              onSubmit: (Object? value) {
                if (value is DateTime) {
                  selectedDate =
                      value; // Store the selected date when submitted
                }
                Navigator.of(context).pop(selectedDate);
              },
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  selectedDate =
                      args.value; // Update selectedDate when selection changes
                }
              },
            ),
          ),
        ),
      );
    },
  );
}
