part of 'signature_cubit.dart';

class SignatureState extends Equatable {
  final SignatureModel? signatureModel;
  final List<SignatureModel>? listSignature;
  final String? error;

  const SignatureState({
    this.signatureModel,
    this.listSignature,
    this.error,
  });

  // bool get updateListSignature {
  //   int current = listSignature!.length;
  //   int previous = 0;

  //   if (current == previous) {
  //     return false;
  //   }
  //   previous = current;
  //   return true;
  // }

  @override
  List<Object?> get props => [signatureModel, listSignature, error];

  SignatureState copyWith({
    SignatureModel? signatureModel,
    List<SignatureModel>? listSignature,
    String? error,
  }) {
    return SignatureState(
      signatureModel: signatureModel ?? this.signatureModel,
      listSignature: listSignature ?? this.listSignature,
      error: error ?? this.error,
    );
  }

}
