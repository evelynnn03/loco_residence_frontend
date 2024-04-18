
import 'package:flutter/material.dart';
import 'package:sef_ass/common/read%20data/get_guard_details.dart';

class GuardDetailsItem extends StatelessWidget {
  final String documentId;
  final bool showImage;

  GuardDetailsItem({required this.documentId, required this.showImage});

  @override
  Widget build(BuildContext context) {
    // Use GuardDetails or any other widget based on the showImage value
    return showImage 
    ? GetGuardDetails(documentId: documentId) 
    : Container();
  }
}
