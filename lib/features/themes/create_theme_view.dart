import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/features/themes/themes_controller.dart';
import 'package:mango/models/app_theme_model.dart';
import 'package:uuid/uuid.dart';

/// Screen to create a custom theme
class CreateThemeView extends StatefulWidget {
  const CreateThemeView({super.key});

  @override
  State<CreateThemeView> createState() => _CreateThemeViewState();
}

class _CreateThemeViewState extends State<CreateThemeView> {
  final _nameController = TextEditingController(text: 'My Theme');

  ThemeBackgroundType _backgroundType = ThemeBackgroundType.solidColor;
  Color _solidColor = const Color(0xFF2D3748);
  Color _gradientStart = const Color(0xFF667EEA);
  Color _gradientEnd = const Color(0xFF764BA2);
  String _imageUrl = '';
  bool _isLocalImage = false;
  Color _textColor = Colors.white;
  Color _accentColor = const Color(0xFFE5C07B);
  ThemeFontChoice _fontChoice = ThemeFontChoice.playfairDisplay;

  final List<Color> _presetColors = const [
    Color(0xFF1A1A1A), // Dark
    Color(0xFF2D3748), // Slate
    Color(0xFF1E3A5F), // Navy
    Color(0xFF134E5E), // Teal
    Color(0xFF2D5016), // Forest
    Color(0xFF4A1942), // Purple
    Color(0xFF3D2914), // Brown
    Color(0xFFF5F0E8), // Beige
    Color(0xFFF8F8F8), // White
  ];

  final List<List<Color>> _presetGradients = const [
    [Color(0xFF667EEA), Color(0xFF764BA2)], // Purple
    [Color(0xFFFF9A9E), Color(0xFFFECFEF)], // Pink
    [Color(0xFF667EEA), Color(0xFF64B5F6)], // Blue
    [Color(0xFF134E5E), Color(0xFF71B280)], // Green
    [Color(0xFFFC466B), Color(0xFF3F5EFB)], // Sunset
    [Color(0xFF0F2027), Color(0xFF2C5364)], // Dark Blue
  ];

  bool _isEditing = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    final AppThemeData? theme = Get.arguments as AppThemeData?;
    if (theme != null && theme.isCustom) {
      _isEditing = true;
      _editingId = theme.id;
      _nameController.text = theme.name;
      _backgroundType = theme.backgroundType;
      _solidColor = theme.solidColor ?? _solidColor;
      if (theme.gradientColors != null && theme.gradientColors!.length >= 2) {
        _gradientStart = theme.gradientColors![0];
        _gradientEnd = theme.gradientColors![1];
      }
      _imageUrl = theme.imageUrl ?? '';
      _isLocalImage = theme.isLocalImage;
      _textColor = theme.textColor;
      _accentColor = theme.accentColor;
      _fontChoice = theme.fontChoice;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _isEditing ? 'Edit Theme' : 'Create Theme',
          style: AppTypography.titleLarge,
        ),
        actions: [
          TextButton(
            onPressed: _saveTheme,
            child: Text(
              'Save',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color:
                    _backgroundType == ThemeBackgroundType.solidColor
                        ? _solidColor
                        : null,
                gradient:
                    _backgroundType == ThemeBackgroundType.gradient
                        ? LinearGradient(
                          colors: [_gradientStart, _gradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                image:
                    _backgroundType == ThemeBackgroundType.image &&
                            _imageUrl.isNotEmpty
                        ? DecorationImage(
                          image:
                              _isLocalImage
                                  ? FileImage(File(_imageUrl)) as ImageProvider
                                  : CachedNetworkImageProvider(_imageUrl),
                          fit: BoxFit.cover,
                          onError: (_, __) {},
                        )
                        : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I am',
                        style: _fontChoice.getTextStyle(
                          fontSize: 14,
                          color: _textColor.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Worthy',
                        style: _fontChoice.getTextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Theme Name
            _buildSectionTitle('Theme Name'),
            TextField(
              controller: _nameController,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Background Type
            _buildSectionTitle('Background'),
            Row(
              children:
                  ThemeBackgroundType.values.map((type) {
                    final isSelected = _backgroundType == type;
                    final label = switch (type) {
                      ThemeBackgroundType.solidColor => 'Solid',
                      ThemeBackgroundType.gradient => 'Gradient',
                      ThemeBackgroundType.image => 'Image',
                    };
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _backgroundType = type),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppColors.accent
                                      : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: AppTypography.labelLarge.copyWith(
                                color:
                                    isSelected
                                        ? AppColors.background
                                        : AppColors.textPrimary,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Background options based on type
            if (_backgroundType == ThemeBackgroundType.solidColor)
              _buildColorPicker(
                colors: _presetColors,
                selected: _solidColor,
                onSelect: (color) => setState(() => _solidColor = color),
              ),

            if (_backgroundType == ThemeBackgroundType.gradient)
              _buildGradientPicker(),

            if (_backgroundType == ThemeBackgroundType.image)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _pickLocalImage,
                      icon: const Icon(Icons.photo_library_rounded),
                      label: const Text('Choose from Gallery'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white10)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.white24, fontSize: 12),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white10)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged:
                        (value) => setState(() {
                          _imageUrl = value;
                          _isLocalImage = false;
                        }),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter Unsplash image URL',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 32),

            // Text Color
            _buildSectionTitle('Text Color'),
            _buildColorPicker(
              colors: const [
                Colors.white,
                Color(0xFF2C2C2C),
                Color(0xFFE5C07B),
              ],
              selected: _textColor,
              onSelect: (color) => setState(() => _textColor = color),
            ),

            const SizedBox(height: 32),

            // Accent Color
            _buildSectionTitle('Accent Color'),
            _buildColorPicker(
              colors: const [
                Color(0xFFE5C07B),
                Color(0xFF64B5F6),
                Color(0xFF81C784),
                Color(0xFFE57373),
                Color(0xFFBA68C8),
                Color(0xFFFFB74D),
                Color(0xFF4DB6AC),
                Color(0xFFF06292),
              ],
              selected: _accentColor,
              onSelect: (color) => setState(() => _accentColor = color),
            ),

            const SizedBox(height: 32),

            // Font Style
            _buildSectionTitle('Font Style'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  ThemeFontChoice.values.map((style) {
                    final isSelected = _fontChoice == style;
                    return GestureDetector(
                      onTap: () => setState(() => _fontChoice = style),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColors.accent : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          style.label,
                          style: style.getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? AppColors.background
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLocalImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageUrl = image.path;
        _isLocalImage = true;
      });
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTypography.titleSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildColorPicker({
    required List<Color> colors,
    required Color selected,
    required Function(Color) onSelect,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ...colors.map((color) {
          final isSelected = selected == color;
          return GestureDetector(
            onTap: () => onSelect(color),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.accent : Colors.white24,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child:
                  isSelected
                      ? Icon(
                        Icons.check_rounded,
                        color:
                            color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                        size: 24,
                      )
                      : null,
            ),
          );
        }),
        // Custom color picker button
        GestureDetector(
          onTap: () async {
            await _pickCustomColor(selected, onSelect);
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.accent,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientPicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ..._presetGradients.map((gradient) {
          final isSelected =
              _gradientStart == gradient[0] && _gradientEnd == gradient[1];
          return GestureDetector(
            onTap: () {
              setState(() {
                _gradientStart = gradient[0];
                _gradientEnd = gradient[1];
              });
            },
            child: Container(
              width: 60,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.accent : Colors.white24,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child:
                  isSelected
                      ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 24,
                      )
                      : null,
            ),
          );
        }),
        // Custom gradient start color
        GestureDetector(
          onTap: () async {
            await _pickCustomColor(_gradientStart, (color) {
              setState(() => _gradientStart = color);
            });
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _gradientStart,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: const Icon(
              Icons.colorize_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        // Custom gradient end color
        GestureDetector(
          onTap: () async {
            await _pickCustomColor(_gradientEnd, (color) {
              setState(() => _gradientEnd = color);
            });
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _gradientEnd,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: const Icon(
              Icons.colorize_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _pickCustomColor(
    Color initialColor,
    Function(Color) onColorChanged,
  ) async {
    return ColorPicker(
      color: initialColor,
      onColorChanged: onColorChanged,
      width: 40,
      height: 40,
      borderRadius: 12,
      spacing: 10,
      runSpacing: 10,
      wheelDiameter: 165,
      heading: Text(
        'Select Color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showColorName: true,
      showMaterialName: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: true,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: true,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      context,
      constraints: const BoxConstraints(
        minHeight: 480,
        minWidth: 320,
        maxWidth: 320,
      ),
    );
  }

  void _saveTheme() {
    final ctrl = Get.find<ThemesController>();

    final theme = AppThemeData(
      id: _isEditing ? _editingId! : 'custom_${const Uuid().v4()}',
      name:
          _nameController.text.trim().isEmpty
              ? 'My Theme'
              : _nameController.text.trim(),
      category: ThemeCategory.myThemes,
      backgroundType: _backgroundType,
      solidColor:
          _backgroundType == ThemeBackgroundType.solidColor
              ? _solidColor
              : null,
      gradientColors:
          _backgroundType == ThemeBackgroundType.gradient
              ? [_gradientStart, _gradientEnd]
              : null,
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.bottomRight,
      imageUrl: _backgroundType == ThemeBackgroundType.image ? _imageUrl : null,
      textColor: _textColor,
      accentColor: _accentColor,
      fontChoice: _fontChoice,
      overlayColor: Colors.black,
      overlayOpacity: 0.3,
      isCustom: true,
      isLocalImage: _isLocalImage,
    );

    ctrl.saveCustomTheme(theme);
    Get.back();
    Get.snackbar(
      _isEditing ? 'Theme Updated' : 'Theme Created',
      '${theme.name} has been saved',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(16),
    );
  }
}
