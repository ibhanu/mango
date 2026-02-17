import 'package:get_it/get_it.dart';
import 'package:mango/repository/affirmation_repository.dart';
import 'package:mango/repository/notification_service.dart';
import 'package:mango/repository/theme_repository.dart';
import 'package:mango/services/mascot_service.dart';
import 'package:mango/services/streak_service.dart';
import 'package:mango/services/widget_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service locator for dependency injection
final getIt = GetIt.instance;

/// Setup all dependencies
Future<void> setupServiceLocator() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Notification Service
  final notificationService = NotificationService();
  await notificationService.init();
  getIt.registerSingleton<NotificationService>(notificationService);

  // Affirmation Repository
  final affirmationRepository = AffirmationRepository(prefs);
  await affirmationRepository.init();
  getIt.registerSingleton<AffirmationRepository>(affirmationRepository);

  // Theme Repository
  final themeRepository = ThemeRepository(prefs);
  getIt.registerSingleton<ThemeRepository>(themeRepository);

  // Mascot Service
  getIt.registerLazySingleton<MascotService>(() => MascotService());

  // Streak Service
  getIt.registerLazySingleton<StreakService>(() => StreakService());

  // Widget Service
  getIt.registerLazySingleton<WidgetService>(() => WidgetService());
}
