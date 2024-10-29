import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/global_variables.dart';
import '../../config/themes/theme_provider.dart';

class ServiceItems extends StatefulWidget {
  final String imageUrl;
  final title;
  final phoneNum;
  const ServiceItems(
      {super.key, required this.imageUrl, this.title, this.phoneNum});

  @override
  State<ServiceItems> createState() => _ServiceItemsState();
}

class _ServiceItemsState extends State<ServiceItems> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    // Color backgroundColor = Theme.of(context).cardColor;
    Color boxShadowColor = Color.fromRGBO(129, 101, 234, 1);
    final screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.32;
    double imageHeight = screenHeight * 0.2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse('tel:${widget.phoneNum}');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            print('Unable to make a call');
          }
        },
        child: Container(
          height: containerHeight,
          width: double.infinity,
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
                .primaryColor, // Set the background color to purple
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.imageUrl,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.error,
                    size: GlobalVariables.responsiveIconSize(context, 60),
                    color: GlobalVariables.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: GlobalVariables.importantTitleStyle(context)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_in_talk,
                          color: GlobalVariables.white,
                          size: GlobalVariables.responsiveIconSize(context, 23),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.phoneNum}',
                          style: TextStyle(
                            fontSize: GlobalVariables.responsiveFontSize(
                                context, 17.0),
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
