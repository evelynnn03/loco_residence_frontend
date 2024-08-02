import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/global_variables.dart';
import '../../config/themes/theme_provider.dart';

class ServiceItems extends StatelessWidget {
  final String imageUrl;
  final title;
  final phoneNum;
  const ServiceItems(
      {super.key, required this.imageUrl, this.title, this.phoneNum});

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    Color backgroundColor = Theme.of(context).cardColor;
    Color boxShadowColor = Color.fromRGBO(129, 101, 234, 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        height: 300,
        width: 400,
        decoration: BoxDecoration(
          boxShadow: mode.isDark
              ? [
                  BoxShadow(
                    color: boxShadowColor,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ), //BoxShadow
                  //BoxShadow
                ]
              : null,
          color: GlobalVariables
              .welcomeColor, // Set the background color to purple
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  size: 60,
                  color: GlobalVariables.greyishPurple,
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 24,
                    color: GlobalVariables.backgroundColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Icon(Icons.phone_in_talk,
                      color: GlobalVariables.backgroundColor),
                  Text(
                    '  $phoneNum',
                    style: TextStyle(
                        fontSize: 17, color: GlobalVariables.backgroundColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
