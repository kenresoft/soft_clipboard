part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final int maxItems;
  final bool backgroundServiceEnabled;
  final bool darkMode;
  final bool groupSimilarItems;
  final bool autoDetectTypes;
  final int clipboardRetentionDays;

  const SettingsLoaded({
    required this.maxItems,
    required this.backgroundServiceEnabled,
    required this.darkMode,
    required this.groupSimilarItems,
    required this.autoDetectTypes,
    required this.clipboardRetentionDays,
  });

  SettingsLoaded copyWith({
    int? maxItems,
    bool? backgroundServiceEnabled,
    bool? darkMode,
    bool? groupSimilarItems,
    bool? autoDetectTypes,
    int? clipboardRetentionDays,
  }) {
    return SettingsLoaded(
      maxItems: maxItems ?? this.maxItems,
      backgroundServiceEnabled: backgroundServiceEnabled ?? this.backgroundServiceEnabled,
      darkMode: darkMode ?? this.darkMode,
      groupSimilarItems: groupSimilarItems ?? this.groupSimilarItems,
      autoDetectTypes: autoDetectTypes ?? this.autoDetectTypes,
      clipboardRetentionDays: clipboardRetentionDays ?? this.clipboardRetentionDays,
    );
  }

  @override
  List<Object> get props =>
      [
        maxItems,
        backgroundServiceEnabled,
        darkMode,
        groupSimilarItems,
        autoDetectTypes,
        clipboardRetentionDays,
      ];
}