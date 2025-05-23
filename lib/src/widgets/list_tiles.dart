import 'package:flutter/material.dart';
import 'package:loco_frontend/src/models/invoice.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key, required this.items});
  final List<Invoice> items;

  @override
  Widget build(BuildContext context) {
    final fontSize = GlobalVariables.listTextStyle(context);
    // used separated for the divider to show after each item
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.grey[300], // Color of the divider
        thickness: 1, // Thickness of the divider
      ),
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.formattedDate,
                  style: fontSize,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(

                  item.amount.toString(),
                  style: fontSize,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  item.invoiceNo.toString(),
                  style: fontSize,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
