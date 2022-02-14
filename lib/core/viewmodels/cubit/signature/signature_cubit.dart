import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../models/signature_model.dart';
import '../../../utils/utils.dart';

part 'signature_state.dart';

class SignatureCubit extends Cubit<SignatureState> {
  SignatureCubit() : super(const SignatureState(listSignature: []));

  final List<SignatureModel> listSignature = [];

  void getSignature({
    required Uint8List signature,
    int? currentPage = 0,
    Size? documentSize = const Size(0, 0),
    Size? documentViewSize = const Size(0, 0),
  }) {
    try {
      // Resize signature image
      final imageScale = Utils.resizeImage(image: signature);

      final modelSignature = SignatureModel(
        id: const Uuid().v4(),
        signature: signature,
        onSelected: true,
        isDelete: false,
        currentPage: currentPage,
        fixedWidth: imageScale.width.toDouble(),
        fixedHeight: imageScale.height.toDouble(),
        documentSize: documentSize,
        documentViewSize: documentViewSize,
      );

      emit(state.copyWith(signatureModel: modelSignature));

      addSignatureToList(modelSignature: state.signatureModel!);
    } catch (e) {
      emit(SignatureState(error: e.toString()));
    }
  }

  void addSignatureToList({required SignatureModel modelSignature}) {
    try {
      listSignature.add(modelSignature);

      emit(state.copyWith(listSignature: listSignature));

      debugPrint('ADD : ${state.listSignature!.length}');
    } catch (e) {
      emit(SignatureState(error: e.toString()));
    }
  }

  void onSelectedSignature(
      {required bool onSelected, SignatureModel? signatureModel}) {
    try {
      if (signatureModel != null) {
        // final index =
        //     listSignature.indexWhere((e) => e.id == signatureModel.id);

        // listSignature[index] = signatureModel.copyWith(onSelected: onSelected);

        // Selected one item signature
        for (var i = 0; i < listSignature.length; i++) {
          if (state.signatureModel!.id == listSignature[i].id) {
            listSignature[i] = signatureModel.copyWith(onSelected: onSelected);
          } else {
            listSignature[i] =
                listSignature[i].copyWith(onSelected: !onSelected);
          }
        }
        emit(state.copyWith(listSignature: listSignature));
      } else {
        if (state.signatureModel != null &&
            state.signatureModel!.onSelected == true &&
            listSignature.isNotEmpty) {
          final index = listSignature.indexWhere((e) => e.onSelected == true);

          listSignature[index] =
              listSignature[index].copyWith(onSelected: false);

          emit(
            state.copyWith(
              signatureModel: state.signatureModel?.copyWith(onSelected: false),
              listSignature: listSignature,
            ),
          );
        }
      }
    } catch (e) {
      emit(SignatureState(error: e.toString()));
    }
  }

  void deleteSignatureScaling({required SignatureModel signature}) {
    try {
      final index = listSignature.indexWhere((e) => e.id == signature.id);
      listSignature.removeAt(index);

      emit(
        state.copyWith(
          signatureModel: signature.copyWith(
            isDelete: true,
            onSelected: false,
          ),
          listSignature: listSignature,
        ),
      );

      debugPrint('DELETE : ${state.listSignature!.length}');
    } catch (e) {
      emit(SignatureState(error: e.toString()));
    }
  }

  void removeSignature() {
    try {
      emit(
        SignatureState(
          signatureModel: null,
          listSignature: state.listSignature,
        ),
      );

      debugPrint(
          'SIGNATURE : ${state.signatureModel} - LIST : ${state.listSignature}');
    } catch (e) {
      emit(SignatureState(error: e.toString()));
    }
  }

  void replaceValueLTWH({
    required SignatureModel signatureModel,
    double? scaleLeftValue = 0.0,
    double? scaleTopValue = 0.0,
    double? scaleWidthValue = 0.0,
    double? scaleHeightValue = 0.0,
    double? fixedLeftValue = 0.0,
    double? fixedTopValue = 0.0,
    double? fixedWidthValue = 0.0,
    double? fixedHeightValue = 0.0,
  }) {
    try {
      final index = listSignature.indexWhere((e) => e.id == signatureModel.id);

      listSignature[index] = signatureModel.copyWith(
        scaleLeft: scaleLeftValue,
        scaleTop: scaleTopValue,
        scaleWidth: scaleWidthValue,
        scaleHeight: scaleHeightValue,
        fixedLeft: fixedLeftValue,
        fixedTop: fixedTopValue,
        fixedWidth: fixedWidthValue,
        fixedHeight: fixedHeightValue,
      );

      emit(
        state.copyWith(
          signatureModel: signatureModel.copyWith(
            scaleLeft: scaleLeftValue,
            scaleTop: scaleTopValue,
            scaleWidth: scaleWidthValue,
            scaleHeight: scaleHeightValue,
            fixedLeft: fixedLeftValue,
            fixedTop: fixedTopValue,
            fixedWidth: fixedWidthValue,
            fixedHeight: fixedHeightValue,
          ),
          listSignature: listSignature,
        ),
      );
    } catch (e) {
      emit(SignatureState(error: e.toString()));
    }
  }

  void onModelSignatureChange({required SignatureModel signatureModel}) {
    try {
      emit(
        state.copyWith(
          signatureModel: signatureModel.copyWith(onSelected: true),
        ),
      );
    } catch (e) {
      emit(SignatureState(error: e.toString()));
    }
  }
}
