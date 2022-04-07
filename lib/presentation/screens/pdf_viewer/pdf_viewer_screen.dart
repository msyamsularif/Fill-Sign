import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thumbnailer/thumbnailer.dart';

import '../../../core/helper/consts.dart';
import '../../../core/utils/utils.dart';
import '../../../core/viewmodels/cubit/pdf_viewer/pdf_viewer_cubit.dart';
import '../../../core/viewmodels/cubit/signature/signature_cubit.dart';
import '../../app_theme.dart';
import '../../components/dialog.dart';
import '../../components/resizeble.dart';
import '../signature/signature_screen.dart';

class PdfViewerScreen extends StatelessWidget {
  final File? pdfFile;

  const PdfViewerScreen({
    Key? key,
    this.pdfFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PdfViewerController _pdfVieweCtrl = PdfViewerController();
    int currentPage = 1;
    Size documentSize = const Size(0, 0);
    Size documentViewSize = const Size(0, 0);

    // Listen state PdfViewerCubit
    BlocProvider.of<PdfViewerCubit>(context).stream.listen((event) {
      documentSize = event.pageSize!;
      documentViewSize = event.rect!.size;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          // Action to asign signature
          IconButton(
            icon: const Icon(MdiIcons.fountainPenTip),
            onPressed: () async {
              context
                  .read<SignatureCubit>()
                  .onSelectedSignature(onSelected: false);

              SharedPreferences prefs = await SharedPreferences.getInstance();

              // Show dialog signature
              await dialogSignature(
                context: context,
                prefs: prefs,
                currentPage: currentPage,
                documentSize: documentSize,
                documentViewSize: documentViewSize,
              );
            },
          ),

          // Action to save signed pdf file
          BlocBuilder<SignatureCubit, SignatureState>(
            buildWhen: (previous, current) =>
                current.listSignature != null ||
                current.listSignature!.isNotEmpty,
            builder: (ctx, state) {
              if (state.listSignature != null &&
                  state.listSignature!.isNotEmpty) {
                return BlocBuilder<PdfViewerCubit, PdfViewerState>(
                  buildWhen: (previous, current) =>
                      previous.currentPage != current.currentPage,
                  builder: (context, stateCurrentPage) {
                    return IconButton(
                      onPressed: () async {
                        final pathDocument = await Utils.addSigantureToPdf(
                          listSignature: state.listSignature!,
                          pdfFile: pdfFile!,
                        );

                        context
                            .read<SignatureCubit>()
                            .onSelectedSignature(onSelected: false);

                        if (pathDocument != null) {
                          // Show dialog preview, share and open pdf file
                          await dialogThumbnailPdf(
                            context: context,
                            pathDocument: pathDocument,
                          );
                        } else {
                          await showInfoDialog(
                            context: context,
                            onOKButtonPressed: () => Navigator.pop(context),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 20),
                                child: Text(
                                  "Failed to save",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(MdiIcons.downloadCircleOutline),
                    );
                  },
                );
              } else {
                return const SizedBox(
                  key: ValueKey('Action Save'),
                );
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        // Action to unselect signature or implement signature
        onTap: () => context
            .read<SignatureCubit>()
            .onSelectedSignature(onSelected: false),
        child: PdfViewer.openFile(
          pdfFile!.path,
          viewerController: _pdfVieweCtrl,
          params: PdfViewerParams(
            scaleEnabled: false,
            layoutPages: (contentViewSize, pageSizes) =>
                // Change PDF page layout
                Utils.changePdfPageLayout(
              contentViewSize: contentViewSize,
              pageSizes: pageSizes,
            ),
            onInteractionEnd: (details) {
              // Get page size document when interaction end
              context.read<PdfViewerCubit>().getPageSizeDocument();
            },
            onViewerControllerInitialized: (p0) {
              Rect? pageRect = _pdfVieweCtrl.ready?.getPageRect(1);

              p0!.addListener(() {
                // Listen for page document changes
                final currentPagePdf = p0.ready?.currentPageNumber;
                currentPage = currentPagePdf!;

                pageRect = _pdfVieweCtrl.ready?.getPageRect(currentPagePdf);

                // Option to find the greatest value on maps
                // final nameWithHighestValue = p0.visiblePages.entries
                //     .reduce((a, b) => a.value >= b.value ? a : b)
                //     .key;

                // Enter current page value and rect page value
                context
                    .read<PdfViewerCubit>()
                    .loadFilePdf(currentPage: currentPagePdf, rect: pageRect);
              });

              // Enter rect page value when initialized
              context.read<PdfViewerCubit>().loadFilePdf(rect: pageRect);

              // Get page size document when initialized
              context.read<PdfViewerCubit>().getPageSizeDocument();
            },
            buildPageOverlay: (context, pageNumber, pageRect) =>
                BlocBuilder<SignatureCubit, SignatureState>(
              buildWhen: (previous, current) {
                // previous.signatureModel?.signature !=
                //     current.signatureModel?.signature ||
                // previous.signatureModel?.onSelected !=
                //     current.signatureModel?.onSelected ||

                return (current.listSignature != null &&
                        current.listSignature!.isNotEmpty) ||
                    current.listSignature == null ||
                    current.listSignature!.isEmpty;
              },
              builder: (context, stateSignature) {
                return BlocConsumer<PdfViewerCubit, PdfViewerState>(
                  listenWhen: (previous, current) =>
                      previous.pdfDocument != current.pdfDocument ||
                      previous.currentPage != current.currentPage ||
                      previous.rect != current.rect ||
                      stateSignature.signatureModel?.signature != null,
                  listener: (context, state) {
                    if (state.pdfDocument != null) {
                      // Checks if listener evaluates to false
                      // ignore: invalid_use_of_protected_member
                      if (_pdfVieweCtrl.hasListeners == false) {
                        _pdfVieweCtrl.removeListener(() {
                          _pdfVieweCtrl.currentPageNumber;
                        });
                        _pdfVieweCtrl.dispose();
                      }
                    } else {
                      _pdfVieweCtrl.dispose();
                      throw 'DOCUMENT IS NOT READY';
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.currentPage != current.currentPage ||
                      previous.rect != current.rect ||
                      previous.pageSize != current.pageSize ||
                      stateSignature.signatureModel != null,
                  builder: (context, state) {
                    // Load signature
                    if (stateSignature.listSignature!.isNotEmpty) {
                      // Filter Signature by current page
                      final filterSignature = stateSignature.listSignature!
                          .where((e) => e.currentPage == pageNumber)
                          .toList();

                      return Stack(
                        children: filterSignature
                            .map(
                              (e) => Resizeble(
                                key: ValueKey(e.id),
                                unSelect: e.onSelected!,
                                width: e.fixedWidth,
                                height: e.fixedHeight,
                                top: (!e.onSelected!) ? e.fixedTop : null,
                                left: (!e.onSelected!) ? e.fixedLeft : null,
                                onPressDelete: () {
                                  context
                                      .read<SignatureCubit>()
                                      .deleteSignatureScaling(signature: e);
                                },
                                onSelected: () {
                                  // Get object Signature
                                  context
                                      .read<SignatureCubit>()
                                      .onModelSignatureChange(
                                        signatureModel: e,
                                      );

                                  // Selected signature
                                  context
                                      .read<SignatureCubit>()
                                      .onSelectedSignature(
                                        onSelected: true,
                                        signatureModel: e,
                                      );
                                },
                                // documentWidthSize: state.pageSize!.width,
                                // documentHeightSize: state.pageSize!.height,
                                // documentWidthView: state.rect?.size.width ?? 0,
                                // documentHeightView:
                                //     state.rect?.size.height ?? 0,
                                documentWidthSize: e.documentSize?.width,
                                documentHeightSize: e.documentSize?.height,
                                documentWidthView: e.documentViewSize?.width,
                                documentHeightView: e.documentViewSize?.height,
                                onFromLTWH: (scaleLeft, scaleTop, scaleWidth,
                                    scaleHeight, left, top, width, height) {
                                  if (e.onSelected!) {
                                    context
                                        .read<SignatureCubit>()
                                        .replaceValueLTWH(
                                          signatureModel: e,
                                          scaleLeftValue: scaleLeft,
                                          scaleTopValue: scaleTop,
                                          scaleWidthValue: scaleWidth,
                                          scaleHeightValue: scaleHeight,
                                          fixedLeftValue: left,
                                          fixedTopValue: top,
                                          fixedWidthValue: width,
                                          fixedHeightValue: height,
                                        );
                                  }
                                },
                                child: Image.memory(
                                  e.signature!,
                                  fit: BoxFit.fill,
                                  color: (e.onSelected == true)
                                      ? Colors.blue[800]
                                      : Colors.black,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }

                    return const SizedBox(key: ValueKey('SizedBox'));
                  },
                );
              },
            ),

            // Displays an indicator when the file has not loaded
            buildPagePlaceholder: (context, pageNumber, pageRect) => Center(
              child: CircularProgressIndicator(
                color: AppTheme.secoundColor,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () => _pdfVieweCtrl.ready?.goToPage(
            pageNumber: _pdfVieweCtrl.pageCount,
          ),
          child: const Icon(MdiIcons.pageLast, color: Colors.white),
        ),
      ),
    );
  }

  /// This function is used to display thumbnails and some actions like share and open file
  ///
  /// [context] A handle to the location of a widget in the widget tree.
  /// [pathDocument] get document path
  Future<void> dialogThumbnailPdf({
    required BuildContext context,
    required String pathDocument,
  }) async {
    showInfoDialog(
      onOKButtonPressed: () => Navigator.pop(context),
      title: pathDocument.split('/').last,
      textTitleAlign: TextAlign.left,
      subTitle: 'Data saved successfully',
      colorSubtitle: Colors.green,
      textSubTitleAlign: TextAlign.left,
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview pdf file
            Container(
              margin: const EdgeInsets.only(right: 20.0),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.3,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black),
              ),
              child: Thumbnail(
                dataResolver: () async =>
                    await File(pathDocument).readAsBytes(),
                mimeType: 'application/pdf',
                widgetSize: MediaQuery.of(context).size.height * 0.19,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action to share pdf file
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                  onPressed: () => Share.shareFiles([pathDocument]),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.shareVariantOutline,
                        color: AppTheme.secoundColor,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Action to open pdf file
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                  onPressed: () => OpenFile.open(pathDocument),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.folderOpenOutline,
                        color: AppTheme.secoundColor,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Open File',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// This method displays a dialog to create or use the created signature
  ///
  /// [context] A handle to the location of a widget in the widget tree.
  /// [prefs] to get shared preferences object for signature
  /// [currentPage] to get the pdf page
  Future<void> dialogSignature({
    required BuildContext context,
    required SharedPreferences prefs,
    required int currentPage,
    required Size documentSize,
    required Size documentViewSize,
  }) async {
    showCustomDialog(
      context: context,
      child: BlocProvider<SignatureCubit>.value(
        value: BlocProvider.of<SignatureCubit>(context),
        child: BlocBuilder<SignatureCubit, SignatureState>(
          buildWhen: (previous, current) => current.signatureModel == null,
          builder: (context, state) {
            return Column(
              children: [
                (prefs.containsKey(keySignature))
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                          onTap: () {
                            context.read<SignatureCubit>().getSignature(
                                  signature: base64Decode(
                                      prefs.getString(keySignature)!),
                                  currentPage: currentPage,
                                  documentSize: documentSize,
                                  documentViewSize: documentViewSize,
                                );

                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 100,
                            decoration:
                                const BoxDecoration(shape: BoxShape.rectangle),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Image.memory(
                                      base64Decode(
                                          prefs.getString(keySignature)!),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    prefs.remove(keySignature);
                                    context
                                        .read<SignatureCubit>()
                                        .removeSignature();
                                  },
                                  icon: const Icon(
                                    MdiIcons.closeCircleOutline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'No Data Found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                    onTap: (!prefs.containsKey(keySignature))
                        ? () async {
                            final Uint8List? resultImgSignature =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignatureScreen(),
                              ),
                            );
                            context.read<SignatureCubit>().getSignature(
                                  signature: resultImgSignature!,
                                  currentPage: currentPage,
                                  documentSize: documentSize,
                                  documentViewSize: documentViewSize,
                                );

                            Navigator.pop(context);
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'Create Signature',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: (!prefs.containsKey(keySignature))
                              ? AppTheme.secoundColor
                              : Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
