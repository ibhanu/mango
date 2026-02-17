import 'package:get/get.dart';
import 'package:mango/features/favorites/favorites_view.dart';
import 'package:mango/features/focus/focus_view.dart';
import 'package:mango/features/home/home_view.dart';
import 'package:mango/features/onboarding/onboarding_view.dart';
import 'package:mango/features/settings/settings_view.dart';
import 'package:mango/features/splash/splash_view.dart';
import 'package:mango/features/themes/create_theme_view.dart';
import 'package:mango/features/themes/theme_mixes_view.dart';
import 'package:mango/features/themes/theme_preview_view.dart';
import 'package:mango/features/themes/themes_view.dart';

/// App route definitions
abstract class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String focus = '/focus';
  static const String themeMixes = '/theme-mixes';
  static const String createTheme = '/create-theme';
  static const String themePreview = '/theme-preview';

  // Get all routes
  static List<GetPage> get pages => [
    GetPage(name: splash, page: () => const SplashView()),
    GetPage(name: onboarding, page: () => const OnboardingView()),
    GetPage(name: home, page: () => const HomeView()),
    GetPage(name: favorites, page: () => const FavoritesView()),
    GetPage(name: settings, page: () => const SettingsView()),
    GetPage(name: focus, page: () => const FocusView()),
    GetPage(name: themeMixes, page: () => const ThemeMixesView()),
    GetPage(name: createTheme, page: () => const CreateThemeView()),
    GetPage(name: themePreview, page: () => const ThemePreviewView()),
    GetPage(
      name: categories, // Legacy compatibility
      page: () => const ThemesView(),
    ),
  ];
}
