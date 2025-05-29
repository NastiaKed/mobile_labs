import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void selectProject(String project) {
    emit(state.copyWith(selectedProject: project));
  }

  void clearSelection() {
    emit(state.copyWith());
  }
}
