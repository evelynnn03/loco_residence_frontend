import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../guard/widget/pop_up_window.dart';
import '../constants/global_variables.dart';
import '../models/announcement.dart';

Widget buildAnnouncementListView({
  required BuildContext context,
  required List<Announcement> announcements,
  ScrollController? scrollController,
  Color? backgroundColor,
  EdgeInsetsGeometry? padding,
}) {
  return Expanded(
    child: ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return GestureDetector(
          onTap: () {
            Popup(
              title: announcement.title,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (announcement.image != null &&
                          announcement.image!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            announcement.image!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(announcement.content),
                      const SizedBox(height: 8),
                      Text(
                        'Updated: ${DateFormat('MMM dd, yyyy').format(announcement.updatedAt)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              buttons: [
                ButtonConfig(
                  text: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ).show(context);
          },
          child: Card(
            color: backgroundColor ?? GlobalVariables.white,
            margin: padding ?? EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcement.title,
                              style: GlobalVariables.bold16(context,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              announcement.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (announcement.image != null &&
                          announcement.image!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            announcement.image!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: 20,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy')
                            .format(announcement.updatedAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize:
                              GlobalVariables.responsiveFontSize(context, 13),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: GlobalVariables.responsiveIconSize(context, 16.0),
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
