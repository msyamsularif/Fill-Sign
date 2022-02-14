import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/signature_model.dart';

class Utils {
  /// This function is used to change the rotation of the mobile screen
  ///
  /// [orientation] used to check the current state of rotation
  static void setOrientation({required Orientation orientation}) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  /// This function is used to save digital signatures to the gallery
  ///
  /// [signature] to parse signature data
  static Future<bool> storeSignature({
    required Uint8List signature,
  }) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().microsecondsSinceEpoch;
    final name = 'signature_$time.png';

    final result =
        await ImageGallerySaver.saveImage(signature, name: name, quality: 100);
    final isSuccess = result['isSuccess'];

    return isSuccess;
  }

  /// This function is used to convert the signature into an image
  ///
  /// [signatureController] used to get signature
  /// [penStorageWidth] to determine the thickness of the streak
  /// [penColor] to determine the color of the pen
  /// [exportBackgroundColor] to determine the background color of the signature
  static Future<Uint8List> exportSignature({
    required SignatureController signatureController,
    double penStorageWidth = 3,
    Color penColor = Colors.black,
    Color exportBackgroundColor = Colors.transparent,
  }) async {
    final exportController = SignatureController(
      penStrokeWidth: penStorageWidth,
      penColor: penColor,
      exportBackgroundColor: exportBackgroundColor,
      points: signatureController.points,
    );

    final signature = await exportController.toPngBytes();
    // final decBase64 = base64Decode(signature.toString());

    // final images = img.decodeImage(decBase64);
    // final imageScale = img.copyResize(images!, height: 100);

    // debugPrint('IMAGES : ${images.width}');
    // debugPrint('IMAGE SCALE : ${imageScale.width}');

    // final result = images.getBytes().buffer.asUint8List();

    exportController.dispose();
    return signature!;
  }

  /// This function is used to select a single file or multiple files as needed
  ///
  /// [type] to select a supported file type
  /// [allowedExtensions] to enter supported extensions
  /// [allowCompression] to determine the file needs to be compressed or not
  /// [allowMultiple] to specify a file can be selected one or more than one
  static Future<File?> filePicker({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowCompression = true,
    bool allowMultiple = false,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowCompression: allowCompression,
        allowMultiple: allowMultiple,
      );

      final File? file = File(result!.files.single.path!);

      return file;
    } catch (e) {
      throw e.toString();
    }
  }

  /// This function is used to insert signature into PDF file
  ///
  /// [listSignature] to enter the list of [SignatureModel] for assign signature.
  /// [pdfFile] to enter a PDF file that will be added a signature.
  static Future<String?> addSigantureToPdf({
    required List<SignatureModel> listSignature,
    required File pdfFile,
    // required int currentPage,
  }) async {
    Directory? directory;
    final statusStorage = await Permission.storage.request();
    final statusManageStorage =
        await Permission.manageExternalStorage.request();

    final PdfDocument document = PdfDocument(
      inputBytes: await pdfFile.readAsBytes(),
    );

    // Get page count
    // final pageCount = document.pages.count;

    // Draw the image to the PDF page
    for (var i = 0; i < listSignature.length; i++) {
      // Get the existing PDF page.
      final PdfPage page = document.pages[listSignature[i].currentPage! - 1];

      final PdfBitmap image = PdfBitmap(listSignature[i].signature!);
      page.graphics.drawImage(
        image,
        Rect.fromLTWH(
          listSignature[i].scaleLeft!,
          listSignature[i].scaleTop!,
          listSignature[i].scaleWidth!,
          listSignature[i].scaleHeight!,
        ),
      );
    }

    // Set filename PDF
    final time = DateTime.now().microsecondsSinceEpoch;
    final fileName = 'PdfEdit_$time.pdf';

    // Save new file PDF to directory
    if (statusStorage.isGranted || statusManageStorage.isGranted) {
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();

        final List<String>? listPath = directory!.path.split('/');
        String newPath = '';

        for (var i = 1; i < listPath!.length; i++) {
          if (listPath[i] != 'Android') {
            newPath += '/' + listPath[i];
          } else {
            break;
          }
        }
        directory = await Directory(newPath + '/Mitra Fill and Sign/Document')
            .create(recursive: true);
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      await File('${directory!.path}/$fileName').writeAsBytes(document.save());
      document.dispose();

      return '${directory.path}/$fileName';
    }
  }

  /// This function is used to get the paper size of the document
  ///
  /// [pdfFile] to enter a PDF file that will be added a signature.
  /// [currentPage] to get the page size of a PDF document.
  static Future<Size?> getSizeDocument({
    required File pdfFile,
    required int currentPage,
  }) async {
    try {
      // Get document
      final PdfDocument document = PdfDocument(
        inputBytes: await pdfFile.readAsBytes(),
      );

      // Get the existing PDF and page size.
      final pageSize = document.pages[currentPage - 1].size;
      debugPrint('PAGE SIZE : $pageSize');

      return pageSize;
    } catch (e) {
      throw e.toString();
    }
  }

  /// This function is used to resize the image
  ///
  /// [image] the image to be resized
  /// [width] Returns a resized copy of the [src] image. If [width] isn't specified, then it will be determined by the aspect ratio of [src] and [height].
  /// [height] Returns a resized copy of the [src] image. If [height] isn't specified, then it will be determined by the aspect ratio of [src] and [width]. The default value is 50
  static img.Image resizeImage({
    required Uint8List image,
    int? width,
    int height = 50,
  }) {
    final images = img.decodeImage(image);
    final resultImageScale = img.copyResize(
      images!,
      width: width,
      height: height,
    );

    return resultImageScale;
  }

  /// This function is used to change the layout on each page
  ///
  /// [contentViewSize] get display size content
  /// [pageSizes] get a list of page size data
  static List<Rect> changePdfPageLayout({
    required Size contentViewSize,
    required List<Size> pageSizes,
  }) {
    List<Rect> rectLayout = [];
    double pageTopDistance = 0.0;

    // Display more than one page layout
    if (pageSizes.length != 1) {
      pageSizes.map((e) {
        rectLayout.add(
          Rect.fromLTWH(
            0,
            pageTopDistance,
            contentViewSize.width,
            e.height / 1.7,
          ),
        );
        pageTopDistance += e.height / 1.65;
      }).toList();
    }

    // Display only one page layout
    else {
      rectLayout.add(
        Rect.fromCenter(
          center: Offset(
            contentViewSize.width / 2,
            contentViewSize.height / 2,
          ),
          width: contentViewSize.width,
          height: pageSizes[0].height / 1.7,
        ),
      );
    }
    return rectLayout;
  }
}
