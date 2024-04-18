import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/global_variables.dart';
import 'theme_provider.dart';

class ImportantItems extends StatefulWidget {
  final String imageUrl;
  final title;
  final phoneNum;
  final address;

  const ImportantItems({
    super.key,
    required this.imageUrl,
    this.title,
    this.phoneNum,
    this.address,
  });

  @override
  State<ImportantItems> createState() => _ImportantItemsState();
}

class _ImportantItemsState extends State<ImportantItems> {
  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    print(mode.isDark);
    Color container = Theme.of(context).cardColor;
    Color boxShadowColor = Color.fromRGBO(129, 101, 234, 1);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
          color: container,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  color: GlobalVariables.backgroundColor,
                  fontWeight: FontWeight.bold,
                ),
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
                    '  ${widget.phoneNum}',
                    style: TextStyle(
                      fontSize: 17,
                      color: GlobalVariables.backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Icon(Icons.location_pin,
                      color: GlobalVariables.backgroundColor),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '  ${widget.address}',
                          style: TextStyle(
                            fontSize: 17,
                            color: GlobalVariables.backgroundColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
