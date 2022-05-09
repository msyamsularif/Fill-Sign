import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thumbnailer/thumbnailer.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/viewmodels/cubit/pdf_viewer/pdf_viewer_cubit.dart';
import '../../../../core/viewmodels/cubit/recent_file/recent_file_cubit.dart';
import '../../../../core/viewmodels/cubit/signature/signature_cubit.dart';
import '../../../app_theme.dart';
import '../../pdf_viewer/pdf_viewer_screen.dart';

class SelectedDocumentsWidget extends StatelessWidget {
  const SelectedDocumentsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File? resultFilePicker;

    final double screenWidth =
        MediaQuery.of(context).size.width; // screen width
    const double paddingCard = 16; // predefined padding for card
    const double totalPadding = paddingCard * 2; // predefined total padding
    const double totalCard = 3; // total card you want to display
    const double totalGap = 2; // total gap between cards
    final double cardWidth = screenWidth * 0.25; // displayed card size
    final double totalCardWidth = cardWidth * totalCard; // total card size
    final double gapResult = (screenWidth - totalPadding - totalCardWidth) /
        totalGap; // gap between cards

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: BlocBuilder<RecentFileCubit, RecentFileState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: state.documentPath.isNotEmpty
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () async {
                    resultFilePicker = await Utils.filePicker(
                      context: context,
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (resultFilePicker != null) {
                      context
                          .read<RecentFileCubit>()
                          .addDocumentPath(resultFilePicker!.path);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider<PdfViewerCubit>(
                                create: (context) => PdfViewerCubit()
                                  ..loadFilePdf(fileDocument: resultFilePicker),
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
                  child: Container(
                    height: state.documentPath.isNotEmpty ? 80 : 200,
                    width: double.infinity,
                    margin: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.secoundColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.secoundColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          MdiIcons.fileDocumentOutline,
                          color: AppTheme.secoundColor,
                          size: 60,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select the document from \nyour device',
                              style: TextStyle(
                                color: AppTheme.secoundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'PDF Only',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.documentPath.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 55,
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1.5,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Recent File',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 55,
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1.5,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.documentPath.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        right: (index == state.documentPath.length - 1)
                            ? paddingCard
                            : gapResult,
                        left: (index == 0) ? paddingCard : 0,
                        top: 25,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            key: ValueKey(state.documentPath[index]),
                            onTap: () {
                              context
                                  .read<RecentFileCubit>()
                                  .selectedDocumentPath(
                                      state.documentPath[index]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<PdfViewerCubit>(
                                        create: (context) => PdfViewerCubit()
                                          ..loadFilePdf(
                                            fileDocument: File(
                                              state.documentPath[index],
                                            ),
                                          ),
                                      ),
                                      BlocProvider<SignatureCubit>(
                                        create: (context) => SignatureCubit(),
                                      ),
                                    ],
                                    child: PdfViewerScreen(
                                      pdfFile: File(state.documentPath[index]),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.17,
                              width: cardWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Thumbnail(
                                dataResolver: () async =>
                                    await File(state.documentPath[index])
                                        .readAsBytes(),
                                mimeType: 'application/pdf',
                                widgetSize:
                                    MediaQuery.of(context).size.height * 0.19,
                              ),
                            ),
                          ),
                          Container(
                            width: cardWidth,
                            margin: const EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: Text(
                              state.documentPath[index].split('/').last,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
