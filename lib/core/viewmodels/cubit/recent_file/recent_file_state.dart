part of 'recent_file_cubit.dart';

class RecentFileState extends Equatable {
  final List<String> documentPath;

  const RecentFileState({
    required this.documentPath,
  });

  @override
  List<Object> get props => [documentPath];

  RecentFileState copyWith({
    List<String>? documentPath,
  }) {
    return RecentFileState(
      documentPath: documentPath ?? this.documentPath,
    );
  }
}
