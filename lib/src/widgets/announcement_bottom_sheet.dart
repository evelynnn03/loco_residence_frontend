import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loco_frontend/src/widgets/announcement_list_view.dart';
import '../constants/global_variables.dart';
import '../models/announcement.dart';

Future<void> showAnnouncementBottomSheet(
  BuildContext context,
  String title,
  List<Announcement> announcements, {
  bool isGuard = false,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (BuildContext context, ScrollController scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: GlobalVariables.secondaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        title,
                        style: GlobalVariables.notifTitleStyle(context),
                      ),
                    ),
                    buildAnnouncementListView(
                      context: context,
                      announcements: announcements,
                      scrollController: scrollController,
                      padding: EdgeInsets.all(10.0),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
