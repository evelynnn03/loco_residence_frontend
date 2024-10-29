import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/global_variables.dart';

class GuardListItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String phoneNum;

  const GuardListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.phoneNum,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse('tel:$phoneNum');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          print('Unable to make a call');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          color: GlobalVariables.primaryColor,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
              radius: 35,
            ),
            title: Text(
              name,
              style: GlobalVariables.bold20(context, GlobalVariables.white),
            ),
            subtitle: Text(
              phoneNum,
              style: TextStyle(
                fontSize: GlobalVariables.responsiveFontSize(context, 14.0),
                color: Colors.white54,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
