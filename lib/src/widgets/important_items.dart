import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/global_variables.dart';
import '../../config/themes/theme_provider.dart';

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
    Color boxShadowColor = Color.fromRGBO(129, 101, 234, 1);
    final screenHeight = MediaQuery.of(context).size.height;

    double imageHeight = screenHeight * 0.2;
    double containerHeight = screenHeight * 0.36;

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            color: GlobalVariables.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.imageUrl,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.error,
                        size: GlobalVariables.responsiveIconSize(context, 60),
                        color: GlobalVariables.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: GlobalVariables.importantTitleStyle(context),
                        overflow: TextOverflow.ellipsis),
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: GlobalVariables.white,
                          size: GlobalVariables.responsiveIconSize(context, 23),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.address}',
                                style: GlobalVariables.importantDetailStyle(
                                    context),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
