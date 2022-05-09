import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/consts.dart';

part 'recent_file_state.dart';

class RecentFileCubit extends Cubit<RecentFileState> {
  RecentFileCubit() : super(const RecentFileState(documentPath: []));

  void loadDocumentPath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> listDocumentPath =
        prefs.getStringList(keyListRecentFile) ?? [];

    emit(state.copyWith(documentPath: listDocumentPath));
  }

  void addDocumentPath(String documentPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (state.documentPath.contains(documentPath)) {
      putFileFirst(documentPath);
      return;
    }

    emit(state.copyWith(documentPath: [documentPath, ...state.documentPath]));

    if (state.documentPath.length > 3) {
      state.documentPath.removeAt(state.documentPath.length - 1);
    }

    prefs.setStringList(keyListRecentFile, state.documentPath);

    state.documentPath.reversed.toList();
  }

  void deleteDocumentPath(String documentPath) {
    state.documentPath.removeWhere((d) => d == documentPath);
    emit(RecentFileState(documentPath: state.documentPath));
  }

  void selectedDocumentPath(String documentPath) {
    emit(state.copyWith(documentPath: [documentPath, ...state.documentPath]));

    if (state.documentPath.contains(documentPath)) {
      putFileFirst(documentPath);
      return;
    }

    if (state.documentPath.length > 3) {
      state.documentPath.removeAt(state.documentPath.length - 1);
    }

    state.documentPath.reversed.toList();
  }

  void putFileFirst(String documentPath) {
    deleteDocumentPath(documentPath);
    addDocumentPath(documentPath);
  }
}
