import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

part 'pdf_viewer_state.dart';

class PdfViewerCubit extends Cubit<PdfViewerState> {
  PdfViewerCubit()
      : super(const PdfViewerState(
          pdfDocument: null,
          rect: null,
          currentPage: 1,
          pageSize: Size(0, 0),
        ));

  void loadFilePdf({File? fileDocument, Rect? rect, int? currentPage}) {
    try {
      emit(
        state.copyWith(
          pdfDocument: fileDocument,
          rect: rect,
          currentPage: currentPage,
        ),
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getPageSizeDocument() async {
    Size? documentSize;

    if (state.pdfDocument != null && state.currentPage != null) {
      documentSize = await Utils.getSizeDocument(
        pdfFile: state.pdfDocument!,
        currentPage: state.currentPage!,
      );

      emit(
        state.copyWith(
          pageSize: documentSize,
        ),
      );
    }
  }
}
