import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/global_variables.dart';
import '../../../config/themes/theme_provider.dart';
import '../../widgets/horizontal_tiles.dart';
import 'reset_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<ThemeProvider>(context);
    Color boxShadowColor = Color.fromRGBO(130, 101, 234, 0.769);
    // Color cardColor = Theme.of(context).cardColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: GlobalVariables.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 25.0),
        child: Column(
          children: [
            HorizontalTiles(
              title: 'Reset Password',
              icon: Icons.arrow_circle_right_outlined,
              routeName: '/reset_password',
            ),
            SizedBox(height: 25),
            HorizontalTiles(
              title: 'Light / Dark Mode',
              icon: mode.isDark ? Icons.light_mode : Icons.dark_mode,
              iconSize: 33,
            ),
          ],
        ),
      ),
    );
  }
}
