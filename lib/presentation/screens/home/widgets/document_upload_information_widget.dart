import 'package:flutter/material.dart';

import '../../../app_theme.dart';

class DocumentUploadInformationWidget extends StatelessWidget {
  final double viewPaddingTop;

  const DocumentUploadInformationWidget({
    Key? key,
    required this.viewPaddingTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: (MediaQuery.of(context).size.height / 2) - viewPaddingTop,
      padding: const EdgeInsets.all(16.0),
      color: AppTheme.secoundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.upload_file_rounded,
              color: Colors.white,
              size: 150,
            ),
            SizedBox(height: 20),
            Text(
              "You Need to Upload Your",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              "Document Files",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Make sure the file to be uploaded is correct \nand in PDF format",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
