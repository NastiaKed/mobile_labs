part of 'stitch_counter_cubit.dart';

class StitchCounterState {
  final int count;

  const StitchCounterState({this.count = 0});

  StitchCounterState copyWith({int? count}) {
    return StitchCounterState(count: count ?? this.count);
  }
}
