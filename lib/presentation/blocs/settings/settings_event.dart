part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class SetMaxItems extends SettingsEvent {
  final int maxItems;

  const SetMaxItems(this.maxItems);

  @override
  List<Object> get props => [maxItems];
}

class ToggleBackgroundService extends SettingsEvent {}

class ToggleDarkMode extends SettingsEvent {}

class ToggleGroupSimilarItems extends SettingsEvent {}

class ToggleAutoDetectTypes extends SettingsEvent {}

class SetClipboardRetentionDays extends SettingsEvent {
  final int days;

  const SetClipboardRetentionDays(this.days);

  @override
  List<Object> get props => [days];
}
