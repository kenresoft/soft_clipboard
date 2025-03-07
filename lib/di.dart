import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soft_clipboard/core/storage/local_storage.dart';
import 'package:soft_clipboard/data/datasources/clipboard_local_datasource.dart';
import 'package:soft_clipboard/data/datasources/clipboard_service.dart';
import 'package:soft_clipboard/data/models/clipboard_item_model.dart';
import 'package:soft_clipboard/data/repositories/clipboard_repository_impl.dart';
import 'package:soft_clipboard/domain/repositories/clipboard_repository.dart';
import 'package:soft_clipboard/domain/usecases/add_clipboard_item.dart';
import 'package:soft_clipboard/domain/usecases/delete_clipboard_item.dart';
import 'package:soft_clipboard/domain/usecases/get_clipboard_items.dart';
import 'package:soft_clipboard/domain/usecases/update_clipboard_item.dart';
import 'package:soft_clipboard/presentation/blocs/clipboard/clipboard_bloc.dart';
import 'package:soft_clipboard/presentation/blocs/settings/settings_bloc.dart';

class DependencyInjection {
  // Private constructor to prevent instantiation
  DependencyInjection._();

  /// Initializes Hive, registers adapters, and opens the necessary box.
  static Future<void> init() async {
    // Initialize Hive for Flutter.
    await Hive.initFlutter();

    // Register Hive adapters (make sure your adapter is generated).
    Hive.registerAdapter(ClipboardItemModelAdapter());

    // Open the box for storing clipboard items.
    await Hive.openBox<ClipboardItemModel>('soft_clipboard_items');
    await LocalStorage.init('soft_clipboard_preference');
  }

  /// Repository Providers to make dependencies available throughout the app.
  static List<RepositoryProvider> get repositoryProviders => [
        // Provide the Hive box.
        RepositoryProvider<Box<ClipboardItemModel>>(
          create: (_) => Hive.box<ClipboardItemModel>('soft_clipboard_items'),
        ),

        // Provide the local data source that uses the Hive box.
        RepositoryProvider<ClipboardLocalDataSource>(
          create: (context) {
            final box = context.read<Box<ClipboardItemModel>>();
            return ClipboardLocalDataSourceImpl(clipboardBox: box);
          },
        ),

        // Provide the repository, built upon the local data source.
        RepositoryProvider<ClipboardRepository>(
          create: (context) {
            final localDataSource = context.read<ClipboardLocalDataSource>();
            return ClipboardRepositoryImpl(localDataSource: localDataSource);
          },
        ),

        // Provide the clipboard service.
        RepositoryProvider<ClipboardService>(
          create: (_) => ClipboardServiceImpl(),
        ),

        // Provide the use cases.
        RepositoryProvider<GetClipboardItems>(
          create: (context) {
            final repository = context.read<ClipboardRepository>();
            return GetClipboardItems(repository);
          },
        ),
        RepositoryProvider<AddClipboardItem>(
          create: (context) {
            final repository = context.read<ClipboardRepository>();
            return AddClipboardItem(repository);
          },
        ),
        RepositoryProvider<UpdateClipboardItem>(
          create: (context) {
            final repository = context.read<ClipboardRepository>();
            return UpdateClipboardItem(repository);
          },
        ),
        RepositoryProvider<DeleteClipboardItem>(
          create: (context) {
            final repository = context.read<ClipboardRepository>();
            return DeleteClipboardItem(repository);
          },
        ),
      ];

  /// Bloc Providers that supply the blocs with their dependencies.
  static List<BlocProvider> get providers => [
        BlocProvider<ClipboardBloc>(
          create: (context) {
            return ClipboardBloc(
              getClipboardItems: context.read<GetClipboardItems>(),
              addClipboardItem: context.read<AddClipboardItem>(),
              updateClipboardItem: context.read<UpdateClipboardItem>(),
              deleteClipboardItem: context.read<DeleteClipboardItem>(),
              clipboardService: context.read<ClipboardService>(),
            );
          },
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => SettingsBloc(),
        ),
      ];
}
