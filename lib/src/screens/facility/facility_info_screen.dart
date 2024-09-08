import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loco_frontend/src/widgets/facility_tiles.dart';

import '../../constants/global_variables.dart';

class FacilityInfoScreen extends StatefulWidget {
  const FacilityInfoScreen({Key? key}) : super(key: key);
  static const String routeName = '/facility_info';

  @override
  _FacilityInfoScreenState createState() => _FacilityInfoScreenState();
}

class _FacilityInfoScreenState extends State<FacilityInfoScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _desController;
  late Animation<double> _titleAnimation;
  late Animation<double> _desAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize title controller
    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize description controller
    _desController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Title animation
    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_titleController);

    // Description animation
    _desAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_desController);

    // Start title animation
    _titleController.forward();

    // Delay description animation by 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _desController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.secondaryColor,
        title: Text(
          'Facility Information',
          style: GlobalVariables.appbarStyle(context),
        ),
        leading: GlobalVariables.backButton(context),
      ),
      body: FacilityTiles(),
      // body: Stack(
      //   children: [
      //     CachedNetworkImage(
      //       imageUrl:
      //           'https://firebasestorage.googleapis.com/v0/b/sef-assignment-223b2.appspot.com/o/gymInfo.jpg?alt=media&token=10706d02-5f8e-4316-bca4-0992019c4a3c',
      //       height: double.infinity,
      //       fit: BoxFit.cover,
      //       errorWidget: (context, url, error) => Icon(
      //         Icons.image,
      //         size: 60,
      //         color: GlobalVariables.greyishPurple,
      //       ),
      //     ),
      //     Positioned(
      //       top: 50,
      //       left: 10,
      //       child: GlobalVariables.backButton(context,
      //           color: GlobalVariables.white),
      //     ),
      //     Positioned(
      //       bottom: 0,
      //       left: 0,
      //       right: 0,
      //       child: Container(
      //         height: MediaQuery.of(context).size.height * 0.9,
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.bottomCenter,
      //             end: Alignment.topCenter,
      //             colors: [Colors.black.withOpacity(1), Colors.transparent],
      //           ),
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       bottom: MediaQuery.of(context).size.height * 0.4,
      //       left: 20,
      //       child: FadeTransition(
      //         opacity: _titleAnimation,
      //         child: Text(
      //           'Loco Gym',
      //           style: GlobalVariables.facilityTitleStyle(context),
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       bottom: MediaQuery.of(context).size.height * 0.1,
      //       left: 20,
      //       child: Container(
      //         width: MediaQuery.of(context).size.width - 40,
      //         child: FadeTransition(
      //           opacity: _desAnimation,
      //           child: RichText(
      //             text: TextSpan(
      //               text: 'Operating hours: \n',
      //               style: GlobalVariables.importantTitleStyle(context),
      //               children: [
      //                 TextSpan(
      //                   text: 'Open daily 6:00am - 10:00pm\n\n',
      //                   style: GlobalVariables.facilityOpenTimeStyle(context),
      //                 ),
      //                 TextSpan(
      //                   text:
      //                       'Step into Loco Gym, your premier residential fitness destination, blending cutting-edge equipment, personalized training, and a vibrant community spirit. Our modern facilities cater to fitness enthusiasts of all levels, offering a unique blend of convenience and camaraderie. At Loco Gym, we prioritize your health and well-being, providing a welcoming space for individuals to embark on their fitness journey right within the comfort of their neighborhood. Join us today!!!',
      //                   style: GlobalVariables.facilityDetailsStyle(context),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _desController.dispose();
    super.dispose();
  }
}
