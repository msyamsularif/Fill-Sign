part of 'pdf_viewer_cubit.dart';

class PdfViewerState extends Equatable {
  final File? pdfDocument;
  final Rect? rect;
  final int? currentPage;
  final Size? pageSize;

  const PdfViewerState({
    this.pdfDocument,
    this.rect,
    this.currentPage,
    this.pageSize,
  });

  @override
  List<Object?> get props => [pdfDocument, rect, currentPage, pageSize];

  PdfViewerState copyWith({
    File? pdfDocument,
    Rect? rect,
    int? currentPage,
    Size? pageSize,
  }) {
    return PdfViewerState(
      pdfDocument: pdfDocument ?? this.pdfDocument,
      rect: rect ?? this.rect,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
