part of 'pdf_viewer_cubit.dart';

class PdfViewerState extends Equatable {
  final File? pdfDocument;
  final Rect? rect;
  final int? currentPage;
  final Size? pageSize;
  final int? totalPage;

  const PdfViewerState({
    this.pdfDocument,
    this.rect,
    this.currentPage,
    this.pageSize,
    this.totalPage,
  });

  @override
  List<Object?> get props => [
        pdfDocument,
        rect,
        currentPage,
        pageSize,
        totalPage,
      ];

  PdfViewerState copyWith({
    File? pdfDocument,
    Rect? rect,
    int? currentPage,
    Size? pageSize,
    int? totalPage,
  }) {
    return PdfViewerState(
      pdfDocument: pdfDocument ?? this.pdfDocument,
      rect: rect ?? this.rect,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}
