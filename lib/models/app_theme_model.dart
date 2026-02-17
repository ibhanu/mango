import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme category for organizing themes
enum ThemeCategory {
  all('All'),
  nature('Nature'),
  ocean('Ocean'),
  cosmic('Cosmic'),
  minimalist('Minimalist'),
  gradient('Gradient'),
  sacred('Sacred'),
  myThemes('My Themes');

  final String label;
  const ThemeCategory(this.label);
}

/// Font style options for themes - mindful Google Fonts
enum ThemeFontChoice {
  playfairDisplay('Playfair Display'),
  cormorant('Cormorant'),
  lora('Lora'),
  raleway('Raleway'),
  quicksand('Quicksand'),
  josefinSans('Josefin Sans'),
  crimsonText('Crimson Text'),
  libreBaskerville('Libre Baskerville'),
  montserrat('Montserrat'),
  comfortaa('Comfortaa'),
  marcellus('Marcellus'),
  alice('Alice'),
  merriweather('Merriweather'),
  nunito('Nunito'),
  gildaDisplay('Gilda Display'),
  tenorSans('Tenor Sans'),
  caveat('Caveat'),
  dancingScript('Dancing Script'),
  pacifico('Pacifico'),
  satisfy('Satisfy'),
  inter('Inter'),
  openSans('Open Sans'),
  robotoSlab('Roboto Slab'),
  spectral('Spectral'),
  cinzel('Cinzel'),
  forum('Forum'),
  ebGaramond('EB Garamond'),
  greatVibes('Great Vibes');

  final String label;
  const ThemeFontChoice(this.label);

  /// Get the TextStyle for this font
  TextStyle getTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    switch (this) {
      case ThemeFontChoice.playfairDisplay:
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.cormorant:
        return GoogleFonts.cormorant(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.lora:
        return GoogleFonts.lora(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.raleway:
        return GoogleFonts.raleway(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.quicksand:
        return GoogleFonts.quicksand(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.josefinSans:
        return GoogleFonts.josefinSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.crimsonText:
        return GoogleFonts.crimsonText(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.libreBaskerville:
        return GoogleFonts.libreBaskerville(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.montserrat:
        return GoogleFonts.montserrat(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.comfortaa:
        return GoogleFonts.comfortaa(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.marcellus:
        return GoogleFonts.marcellus(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.alice:
        return GoogleFonts.alice(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.merriweather:
        return GoogleFonts.merriweather(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.nunito:
        return GoogleFonts.nunito(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.gildaDisplay:
        return GoogleFonts.gildaDisplay(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.tenorSans:
        return GoogleFonts.tenorSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.caveat:
        return GoogleFonts.caveat(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.dancingScript:
        return GoogleFonts.dancingScript(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.pacifico:
        return GoogleFonts.pacifico(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.satisfy:
        return GoogleFonts.satisfy(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.inter:
        return GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.openSans:
        return GoogleFonts.openSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.robotoSlab:
        return GoogleFonts.robotoSlab(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.spectral:
        return GoogleFonts.spectral(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.cinzel:
        return GoogleFonts.cinzel(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.forum:
        return GoogleFonts.forum(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.ebGaramond:
        return GoogleFonts.ebGaramond(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case ThemeFontChoice.greatVibes:
        return GoogleFonts.greatVibes(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
    }
  }
}

/// Background type for themes
enum ThemeBackgroundType { image, solidColor, gradient }

/// Complete theme data model
class AppThemeData {
  final String id;
  final String name;
  final ThemeCategory category;
  final ThemeBackgroundType backgroundType;

  /// For image backgrounds - Unsplash URL
  final String? imageUrl;

  /// For solid color backgrounds
  final Color? solidColor;

  /// For gradient backgrounds
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  /// Text styling
  final Color textColor;
  final Color accentColor;
  final ThemeFontChoice fontChoice;

  /// Optional overlay for better text readability on images
  final Color? overlayColor;
  final double overlayOpacity;

  /// Whether this is a user-created custom theme
  final bool isCustom;

  /// Whether this theme is favorited
  bool isFavorite;

  /// Whether image is a local file
  final bool isLocalImage;

  AppThemeData({
    required this.id,
    required this.name,
    required this.category,
    required this.backgroundType,
    this.imageUrl,
    this.solidColor,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.textColor = Colors.white,
    this.accentColor = const Color(0xFFE5C07B),
    this.fontChoice = ThemeFontChoice.playfairDisplay,
    this.overlayColor,
    this.overlayOpacity = 0.3,
    this.isCustom = false,
    this.isFavorite = false,
    this.isLocalImage = false,
  });

  /// Create gradient decoration
  Gradient? get gradient {
    if (backgroundType != ThemeBackgroundType.gradient ||
        gradientColors == null) {
      return null;
    }
    return LinearGradient(
      begin: gradientBegin ?? Alignment.topLeft,
      end: gradientEnd ?? Alignment.bottomRight,
      colors: gradientColors!,
    );
  }

  /// Create from JSON (for persistence)
  factory AppThemeData.fromJson(Map<String, dynamic> json) {
    return AppThemeData(
      id: json['id'] as String,
      name: json['name'] as String,
      category: ThemeCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ThemeCategory.myThemes,
      ),
      backgroundType: ThemeBackgroundType.values.firstWhere(
        (t) => t.name == json['backgroundType'],
        orElse: () => ThemeBackgroundType.solidColor,
      ),
      imageUrl: json['imageUrl'] as String?,
      solidColor:
          json['solidColor'] != null ? Color(json['solidColor'] as int) : null,
      gradientColors:
          (json['gradientColors'] as List<dynamic>?)
              ?.map((c) => Color(c as int))
              .toList(),
      textColor: Color(json['textColor'] as int? ?? 0xFFFFFFFF),
      accentColor: Color(json['accentColor'] as int? ?? 0xFFE5C07B),
      fontChoice: ThemeFontChoice.values.firstWhere(
        (f) => f.name == json['fontChoice'],
        orElse: () => ThemeFontChoice.playfairDisplay,
      ),
      overlayColor:
          json['overlayColor'] != null
              ? Color(json['overlayColor'] as int)
              : null,
      overlayOpacity: (json['overlayOpacity'] as num?)?.toDouble() ?? 0.3,
      isCustom: json['isCustom'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isLocalImage: json['isLocalImage'] as bool? ?? false,
    );
  }

  /// Convert to JSON (for persistence)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'backgroundType': backgroundType.name,
      'imageUrl': imageUrl,
      'solidColor': solidColor?.toARGB32(),
      'gradientColors': gradientColors?.map((c) => c.toARGB32()).toList(),
      'textColor': textColor.toARGB32(),
      'accentColor': accentColor.toARGB32(),
      'fontChoice': fontChoice.name,
      'overlayColor': overlayColor?.toARGB32(),
      'overlayOpacity': overlayOpacity,
      'isCustom': isCustom,
      'isFavorite': isFavorite,
      'isLocalImage': isLocalImage,
    };
  }

  AppThemeData copyWith({
    String? id,
    String? name,
    ThemeCategory? category,
    ThemeBackgroundType? backgroundType,
    String? imageUrl,
    Color? solidColor,
    List<Color>? gradientColors,
    AlignmentGeometry? gradientBegin,
    AlignmentGeometry? gradientEnd,
    Color? textColor,
    Color? accentColor,
    ThemeFontChoice? fontChoice,
    Color? overlayColor,
    double? overlayOpacity,
    bool? isCustom,
    bool? isFavorite,
    bool? isLocalImage,
  }) {
    return AppThemeData(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      backgroundType: backgroundType ?? this.backgroundType,
      imageUrl: imageUrl ?? this.imageUrl,
      solidColor: solidColor ?? this.solidColor,
      gradientColors: gradientColors ?? this.gradientColors,
      gradientBegin: gradientBegin ?? this.gradientBegin,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
      fontChoice: fontChoice ?? this.fontChoice,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      isCustom: isCustom ?? this.isCustom,
      isFavorite: isFavorite ?? this.isFavorite,
      isLocalImage: isLocalImage ?? this.isLocalImage,
    );
  }
}

/// Default themes collection - 21 mindful themes
class DefaultThemes {
  static const String _unsplash = 'https://images.unsplash.com';

  static List<AppThemeData> get all => [
    // ========== NATURE (5) ==========
    AppThemeData(
      id: 'nature_forest_dawn',
      name: 'Forest Dawn',
      category: ThemeCategory.nature,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1542273917363-3b1817f69a2d?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFF90C67C),
      overlayColor: Colors.black,
      overlayOpacity: 0.35,
    ),
    AppThemeData(
      id: 'nature_mountain',
      name: 'Mountain Serenity',
      category: ThemeCategory.nature,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1506905925346-21bda4d32df4?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFF87CEEB),
      overlayColor: Colors.black,
      overlayOpacity: 0.25,
    ),
    AppThemeData(
      id: 'nature_cherry',
      name: 'Cherry Blossom',
      category: ThemeCategory.nature,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1522383225653-ed111181a951?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFFFB7C5),
      overlayColor: Colors.black,
      overlayOpacity: 0.3,
    ),
    AppThemeData(
      id: 'nature_autumn',
      name: 'Autumn Leaves',
      category: ThemeCategory.nature,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFE5A853),
      overlayColor: Colors.black,
      overlayOpacity: 0.35,
    ),
    AppThemeData(
      id: 'nature_rainforest',
      name: 'Rainforest',
      category: ThemeCategory.nature,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1448375240586-882707db888b?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFF228B22),
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
    ),

    // ========== OCEAN (4) ==========
    AppThemeData(
      id: 'ocean_sunset',
      name: 'Sunset Beach',
      category: ThemeCategory.ocean,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1507525428034-b723cf961d3e?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFFFD700),
      overlayColor: Colors.black,
      overlayOpacity: 0.25,
    ),
    AppThemeData(
      id: 'ocean_deep',
      name: 'Deep Ocean',
      category: ThemeCategory.ocean,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1518837695005-2083093ee35b?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFF00CED1),
      overlayColor: Colors.black,
      overlayOpacity: 0.3,
    ),
    AppThemeData(
      id: 'ocean_coral',
      name: 'Coral Reef',
      category: ThemeCategory.ocean,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1546026423-cc4642628d2b?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFFF7F50),
      overlayColor: Colors.black,
      overlayOpacity: 0.35,
    ),
    AppThemeData(
      id: 'ocean_misty',
      name: 'Misty Shore',
      category: ThemeCategory.ocean,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1505142468610-359e7d316be0?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFB0C4DE),
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
    ),

    // ========== COSMIC (3) ==========
    AppThemeData(
      id: 'cosmic_stars',
      name: 'Starfield',
      category: ThemeCategory.cosmic,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1419242902214-272b3f66ee7a?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFE6E6FA),
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
    ),
    AppThemeData(
      id: 'cosmic_aurora',
      name: 'Aurora',
      category: ThemeCategory.cosmic,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1531366936337-7c912a4589a7?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFF7FFFD4),
      overlayColor: Colors.black,
      overlayOpacity: 0.25,
    ),
    AppThemeData(
      id: 'cosmic_nebula',
      name: 'Nebula',
      category: ThemeCategory.cosmic,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1462331940025-496dfbfc7564?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFDA70D6),
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
    ),

    // ========== MINIMALIST (4) ==========
    AppThemeData(
      id: 'minimal_white',
      name: 'Pure White',
      category: ThemeCategory.minimalist,
      backgroundType: ThemeBackgroundType.solidColor,
      solidColor: const Color(0xFFF8F8F8),
      textColor: const Color(0xFF2C2C2C),
      accentColor: const Color(0xFF6B7280),
    ),
    AppThemeData(
      id: 'minimal_gray',
      name: 'Soft Gray',
      category: ThemeCategory.minimalist,
      backgroundType: ThemeBackgroundType.solidColor,
      solidColor: const Color(0xFF374151),
      textColor: Colors.white,
      accentColor: const Color(0xFF9CA3AF),
    ),
    AppThemeData(
      id: 'minimal_beige',
      name: 'Warm Beige',
      category: ThemeCategory.minimalist,
      backgroundType: ThemeBackgroundType.solidColor,
      solidColor: const Color(0xFFF5F0E8),
      textColor: const Color(0xFF3D3D3D),
      accentColor: const Color(0xFFBEA77E),
    ),
    AppThemeData(
      id: 'minimal_dark',
      name: 'Dark Mode',
      category: ThemeCategory.minimalist,
      backgroundType: ThemeBackgroundType.solidColor,
      solidColor: const Color(0xFF1A1A1A),
      textColor: Colors.white,
      accentColor: const Color(0xFFE5C07B),
    ),

    // ========== GRADIENT (3) ==========
    AppThemeData(
      id: 'gradient_dawn',
      name: 'Dawn',
      category: ThemeCategory.gradient,
      backgroundType: ThemeBackgroundType.gradient,
      gradientColors: const [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.bottomRight,
      textColor: const Color(0xFF2C2C2C),
      accentColor: const Color(0xFFE91E63),
    ),
    AppThemeData(
      id: 'gradient_ocean',
      name: 'Ocean Breeze',
      category: ThemeCategory.gradient,
      backgroundType: ThemeBackgroundType.gradient,
      gradientColors: const [Color(0xFF667EEA), Color(0xFF64B5F6)],
      gradientBegin: Alignment.topCenter,
      gradientEnd: Alignment.bottomCenter,
      textColor: Colors.white,
      accentColor: const Color(0xFF03A9F4),
    ),
    AppThemeData(
      id: 'gradient_forest',
      name: 'Forest Mist',
      category: ThemeCategory.gradient,
      backgroundType: ThemeBackgroundType.gradient,
      gradientColors: const [Color(0xFF134E5E), Color(0xFF71B280)],
      gradientBegin: Alignment.topCenter,
      gradientEnd: Alignment.bottomCenter,
      textColor: Colors.white,
      accentColor: const Color(0xFF81C784),
    ),

    // ========== SACRED (2) ==========
    AppThemeData(
      id: 'sacred_mandala',
      name: 'Mandala',
      category: ThemeCategory.sacred,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1545558014-8692077e9b5c?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFFFD700),
      overlayColor: Colors.black,
      overlayOpacity: 0.45,
    ),
    AppThemeData(
      id: 'sacred_zen',
      name: 'Zen Garden',
      category: ThemeCategory.sacred,
      backgroundType: ThemeBackgroundType.image,
      imageUrl: '$_unsplash/photo-1518495973542-4542c06a5843?w=800&q=80',
      textColor: Colors.white,
      accentColor: const Color(0xFFA8D8A8),
      overlayColor: Colors.black,
      overlayOpacity: 0.35,
    ),
  ];

  /// Get default theme by ID
  static AppThemeData? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get themes by category
  static List<AppThemeData> getByCategory(ThemeCategory category) {
    if (category == ThemeCategory.all) return all;
    return all.where((t) => t.category == category).toList();
  }
}
