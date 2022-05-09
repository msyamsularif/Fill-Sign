import 'package:flutter/material.dart';

import 'widgets/document_upload_information_widget.dart';
import 'widgets/selected_document_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocumentUploadInformationWidget(
              viewPaddingTop: MediaQuery.of(context).viewPadding.top,
            ),
            const SelectedDocumentsWidget(),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           RichText(
    //             textScaleFactor: MediaQuery.of(context).textScaleFactor,
    //             text: TextSpan(
    //               style: const TextStyle(
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 24,
    //                 height: 1.5,
    //               ),
    //               children: [
    //                 const TextSpan(text: 'Select a from to\n'),
    //                 TextSpan(
    //                   text: 'Fill Out\n',
    //                   style: TextStyle(color: AppTheme.secoundColor),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             height: MediaQuery.of(context).size.height * 0.5,
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: AppTheme.secoundColor.withOpacity(0.1),
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //             child: DottedBorder(
    //               color: AppTheme.secoundColor,
    //               borderType: BorderType.RRect,
    //               radius: const Radius.circular(10),
    //               dashPattern: const [10, 5, 10, 5, 10, 5],
    //               child: Center(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () async {
    //                         resultFilePicker = await Utils.filePicker(
    //                           context: context,
    //                           type: FileType.custom,
    //                           allowedExtensions: ['pdf'],
    //                         );
    //                         if (resultFilePicker != null) {
    //                           Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                               builder: (_) => MultiBlocProvider(
    //                                 providers: [
    //                                   BlocProvider<PdfViewerCubit>(
    //                                     create: (context) => PdfViewerCubit()
    //                                       ..loadFilePdf(
    //                                           fileDocument: resultFilePicker),
    //                                   ),
    //                                   BlocProvider<SignatureCubit>(
    //                                     create: (context) => SignatureCubit(),
    //                                   ),
    //                                 ],
    //                                 child: PdfViewerScreen(
    //                                   pdfFile: resultFilePicker,
    //                                 ),
    //                               ),
    //                             ),
    //                           );
    //                         }
    //                       },
    //                       child: Icon(
    //                         MdiIcons.filePlus,
    //                         color: AppTheme.secoundColor,
    //                         size: 80,
    //                       ),
    //                     ),
    //                     const Text(
    //                       'Upload Your File',
    //                       style: TextStyle(
    //                         fontWeight: FontWeight.w500,
    //                         fontSize: 16,
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
