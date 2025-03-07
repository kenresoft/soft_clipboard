import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_clipboard/core/storage/local_storage.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // Keys for storage
  static const String _kMaxItemsKey = 'max_items';
  static const String _kBackgroundServiceKey = 'background_service_enabled';
  static const String _kDarkModeKey = 'dark_mode';
  static const String _kGroupSimilarItemsKey = 'group_similar_items';
  static const String _kAutoDetectTypesKey = 'auto_detect_types';
  static const String _kClipboardRetentionDaysKey = 'clipboard_retention_days';

  // Default values
  static const int defaultMaxItems = 100;
  static const bool defaultBackgroundServiceEnabled = true;
  static const bool defaultDarkMode = false;
  static const bool defaultGroupSimilarItems = true;
  static const bool defaultAutoDetectTypes = true;
  static const int defaultClipboardRetentionDays = 7;

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<SetMaxItems>(_onSetMaxItems);
    on<ToggleBackgroundService>(_onToggleBackgroundService);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ToggleGroupSimilarItems>(_onToggleGroupSimilarItems);
    on<ToggleAutoDetectTypes>(_onToggleAutoDetectTypes);
    on<SetClipboardRetentionDays>(_onSetClipboardRetentionDays);

    // Load settings when bloc is created
    add(LoadSettings());
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    final maxItems = LocalStorage.get<int>(_kMaxItemsKey) ?? defaultMaxItems;
    final backgroundServiceEnabled = LocalStorage.get<bool>(_kBackgroundServiceKey) ?? defaultBackgroundServiceEnabled;
    final darkMode = LocalStorage.get<bool>(_kDarkModeKey) ?? defaultDarkMode;
    final groupSimilarItems = LocalStorage.get<bool>(_kGroupSimilarItemsKey) ?? defaultGroupSimilarItems;
    final autoDetectTypes = LocalStorage.get<bool>(_kAutoDetectTypesKey) ?? defaultAutoDetectTypes;
    final clipboardRetentionDays = LocalStorage.get<int>(_kClipboardRetentionDaysKey) ?? defaultClipboardRetentionDays;

    emit(SettingsLoaded(
      maxItems: maxItems,
      backgroundServiceEnabled: backgroundServiceEnabled,
      darkMode: darkMode,
      groupSimilarItems: groupSimilarItems,
      autoDetectTypes: autoDetectTypes,
      clipboardRetentionDays: clipboardRetentionDays,
    ));
  }

  Future<void> _onSetMaxItems(SetMaxItems event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await LocalStorage.set<int>(_kMaxItemsKey, event.maxItems);
      emit(currentState.copyWith(maxItems: event.maxItems));
    }
  }

  Future<void> _onToggleBackgroundService(ToggleBackgroundService event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newValue = !currentState.backgroundServiceEnabled;
      await LocalStorage.set<bool>(_kBackgroundServiceKey, newValue);
      emit(currentState.copyWith(backgroundServiceEnabled: newValue));
    }
  }

  Future<void> _onToggleDarkMode(ToggleDarkMode event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newValue = !currentState.darkMode;
      await LocalStorage.set<bool>(_kDarkModeKey, newValue);
      emit(currentState.copyWith(darkMode: newValue));
    }
  }

  Future<void> _onToggleGroupSimilarItems(ToggleGroupSimilarItems event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newValue = !currentState.groupSimilarItems;
      await LocalStorage.set<bool>(_kGroupSimilarItemsKey, newValue);
      emit(currentState.copyWith(groupSimilarItems: newValue));
    }
  }

  Future<void> _onToggleAutoDetectTypes(ToggleAutoDetectTypes event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newValue = !currentState.autoDetectTypes;
      await LocalStorage.set<bool>(_kAutoDetectTypesKey, newValue);
      emit(currentState.copyWith(autoDetectTypes: newValue));
    }
  }

  Future<void> _onSetClipboardRetentionDays(SetClipboardRetentionDays event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await LocalStorage.set<int>(_kClipboardRetentionDaysKey, event.days);
      emit(currentState.copyWith(clipboardRetentionDays: event.days));
    }
  }
}
