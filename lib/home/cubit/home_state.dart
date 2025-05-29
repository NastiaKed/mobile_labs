part of 'home_cubit.dart';


@immutable
class HomeState {
  final List<String> projects;
  final String? selectedProject;

  const HomeState({
    required this.projects,
    this.selectedProject,
  });

  factory HomeState.initial() => const HomeState(
    projects: [
      '🌸 Ковдра з бабусиних квадратів',
      '🧣 Теплий зимовий шарф',
      '🧶 Амігурумі зайчик',
      '👜 В’яжена бохо-сумка',
    ],
  );

  HomeState copyWith({
    List<String>? projects,
    String? selectedProject,
  }) {
    return HomeState(
      projects: projects ?? this.projects,
      selectedProject: selectedProject,
    );
  }
}
