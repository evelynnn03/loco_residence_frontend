import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loco_frontend/src/constants/global_variables.dart';
import 'package:loco_frontend/src/widgets/buttons.dart';

Future<void> showBottomSheetModal(
  BuildContext context,
  String title,
  String content,
  bool button, {
  String? buttonText,
  bool isBooking = false,
  List<List<String>>? rooms,
  VoidCallback? onTap,
}) async {
  List<bool> isSelectedList = List<bool>.filled(rooms?.length ?? 0, false);
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: [
                  isBooking
                      ? BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )
                      : Container(),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isBooking ? Colors.white54 : Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 5,
                          width: 40,
                          decoration: BoxDecoration(
                            color: GlobalVariables.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            title,
                            style: GlobalVariables.notifTitleStyle(context),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Text(
                                    content,
                                    style:
                                        GlobalVariables.listTextStyle(context),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Display lists of available rooms
                                if (isBooking && rooms != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: Text(
                                          'Choose a location',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 15.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: rooms.length,
                                            itemBuilder: (context, index) {
                                              final room = rooms[index];
                                              final roomNumber = room[0];
                                              final facility = room[1];
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        for (int i = 0;
                                                            i <
                                                                isSelectedList
                                                                    .length;
                                                            i++) {
                                                          isSelectedList[i] =
                                                              i == index;
                                                        }
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5.0),
                                                      child: Container(
                                                        height: 180,
                                                        width: 150,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isSelectedList[
                                                                  index]
                                                              ? GlobalVariables
                                                                  .primaryColor
                                                              : GlobalVariables
                                                                  .secondaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              roomNumber,
                                                              style: TextStyle(
                                                                fontSize: 25,
                                                                color: isSelectedList[
                                                                        index]
                                                                    ? GlobalVariables
                                                                        .secondaryColor
                                                                    : GlobalVariables
                                                                        .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 8.0),
                                                              child: Text(
                                                                facility,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: isSelectedList[
                                                                          index]
                                                                      ? GlobalVariables
                                                                          .secondaryColor
                                                                      : GlobalVariables
                                                                          .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (button && buttonText != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MyButton(
                              text: buttonText,
                              onTap: onTap ?? () => Navigator.pop(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}
