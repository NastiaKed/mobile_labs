import 'package:flutter_bloc/flutter_bloc.dart';

part 'stitch_counter_state.dart';

class StitchCounterCubit extends Cubit<StitchCounterState> {
  StitchCounterCubit() : super(const StitchCounterState());

  void updateStitchCount(int count) {
    emit(state.copyWith(count: count));
  }

  void reset() {
    emit(const StitchCounterState());
  }
}
