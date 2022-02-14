import 'dart:typed_data';

import 'package:flutter/material.dart';

class SignatureModel {
  final String id;
  final Uint8List? signature;
  final double? scaleLeft;
  final double? scaleTop;
  final double? scaleWidth;
  final double? scaleHeight;
  final double? fixedLeft;
  final double? fixedTop;
  final double? fixedWidth;
  final double? fixedHeight;
  final int? currentPage;
  final bool? onSelected;
  final bool? isDelete;
  final Size? documentSize;
  final Size? documentViewSize;

  SignatureModel({
    required this.id,
    this.signature,
    this.scaleLeft = 0.0,
    this.scaleTop = 0.0,
    this.scaleWidth = 0.0,
    this.scaleHeight = 0.0,
    this.fixedLeft,
    this.fixedTop,
    this.fixedWidth,
    this.fixedHeight,
    this.currentPage = 0,
    this.onSelected = true,
    this.isDelete = false,
    this.documentSize,
    this.documentViewSize,
  });

  SignatureModel copyWith({
    String? id,
    Uint8List? signature,
    double? scaleLeft,
    double? scaleTop,
    double? scaleWidth,
    double? scaleHeight,
    double? fixedLeft,
    double? fixedTop,
    double? fixedWidth,
    double? fixedHeight,
    int? currentPage,
    bool? onSelected,
    bool? isDelete,
    Size? documentSize,
    Size? documentViewSize,
  }) {
    return SignatureModel(
      id: id ?? this.id,
      signature: signature ?? this.signature,
      scaleLeft: scaleLeft ?? this.scaleLeft,
      scaleTop: scaleTop ?? this.scaleTop,
      scaleWidth: scaleWidth ?? this.scaleWidth,
      scaleHeight: scaleHeight ?? this.scaleHeight,
      fixedLeft: fixedLeft ?? this.fixedLeft,
      fixedTop: fixedTop ?? this.fixedTop,
      fixedWidth: fixedWidth ?? this.fixedWidth,
      fixedHeight: fixedHeight ?? this.fixedHeight,
      currentPage: currentPage ?? this.currentPage,
      onSelected: onSelected ?? this.onSelected,
      isDelete: isDelete ?? this.isDelete,
      documentSize: documentSize ?? this.documentSize,
      documentViewSize: documentViewSize ?? this.documentViewSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SignatureModel &&
      other.id == id &&
      other.signature == signature &&
      other.scaleLeft == scaleLeft &&
      other.scaleTop == scaleTop &&
      other.scaleWidth == scaleWidth &&
      other.scaleHeight == scaleHeight &&
      other.fixedLeft == fixedLeft &&
      other.fixedTop == fixedTop &&
      other.fixedWidth == fixedWidth &&
      other.fixedHeight == fixedHeight &&
      other.currentPage == currentPage &&
      other.onSelected == onSelected &&
      other.isDelete == isDelete &&
      other.documentSize == documentSize &&
      other.documentViewSize == documentViewSize;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      signature.hashCode ^
      scaleLeft.hashCode ^
      scaleTop.hashCode ^
      scaleWidth.hashCode ^
      scaleHeight.hashCode ^
      fixedLeft.hashCode ^
      fixedTop.hashCode ^
      fixedWidth.hashCode ^
      fixedHeight.hashCode ^
      currentPage.hashCode ^
      onSelected.hashCode ^
      isDelete.hashCode ^
      documentSize.hashCode ^
      documentViewSize.hashCode;
  }
}
