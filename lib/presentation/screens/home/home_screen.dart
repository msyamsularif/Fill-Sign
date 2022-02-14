import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/utils/utils.dart';
import '../../../core/viewmodels/cubit/pdf_viewer/pdf_viewer_cubit.dart';
import '../../../core/viewmodels/cubit/signature/signature_cubit.dart';
import '../../app_theme.dart';
import '../pdf_viewer/pdf_viewer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File? resultFilePicker;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Select a from to\n'),
                    TextSpan(
                      text: 'Fill Out\n',
                      style: TextStyle(color: AppTheme.secoundColor),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.secoundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DottedBorder(
                  color: AppTheme.secoundColor,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 5, 10, 5, 10, 5],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            resultFilePicker = await Utils.filePicker(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (resultFilePicker != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<PdfViewerCubit>(
                                        create: (context) => PdfViewerCubit()
                                          ..loadFilePdf(
                                              fileDocument: resultFilePicker),
                                      ),
                                      BlocProvider<SignatureCubit>(
                                        create: (context) => SignatureCubit(),
                                      ),
                                    ],
                                    child: PdfViewerScreen(
                                      pdfFile: resultFilePicker,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Icon(
                            MdiIcons.filePlus,
                            color: AppTheme.secoundColor,
                            size: 80,
                          ),
                        ),
                        const Text(
                          'Upload Your File',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
