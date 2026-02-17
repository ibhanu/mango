import 'package:flutter/material.dart';

/// Affirmation category model
class AffirmationCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  const AffirmationCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });

  factory AffirmationCategory.fromJson(Map<String, dynamic> json) {
    return AffirmationCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: _getIconData(json['icon'] as String),
      color: Color(int.parse(json['color'] as String, radix: 16)),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint.toString(),
      'color': color.toARGB32().toRadixString(16),
      'description': description,
    };
  }

  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'emoji_emotions':
        return Icons.emoji_emotions_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'health_and_safety':
        return Icons.health_and_safety_rounded;
      case 'people':
        return Icons.people_rounded;
      case 'diamond':
        return Icons.diamond_rounded;
      case 'spa':
        return Icons.spa_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}

/// Group of categories
class CategorySection {
  final String title;
  final List<AffirmationCategory> categories;

  const CategorySection({required this.title, required this.categories});
}

/// Predefined categories
class AppCategories {
  static const List<CategorySection> sections = [
    CategorySection(
      title: 'Daily Mindset',
      categories: [
        AffirmationCategory(
          id: 'self_love',
          name: 'Self-Love',
          icon: Icons.favorite_rounded,
          color: Color(0xFFE91E63),
          description: 'Embrace and appreciate yourself',
        ),
        AffirmationCategory(
          id: 'confidence',
          name: 'Confidence',
          icon: Icons.star_rounded,
          color: Color(0xFFFF9800),
          description: 'Build unshakeable self-belief',
        ),
        AffirmationCategory(
          id: 'gratitude',
          name: 'Gratitude',
          icon: Icons.emoji_emotions_rounded,
          color: Color(0xFF4CAF50),
          description: 'Appreciate life\'s blessings',
        ),
        AffirmationCategory(
          id: 'self_esteem',
          name: 'Self-Esteem',
          icon: Icons.face_rounded,
          color: Color(0xFF009688),
          description: 'Value your true worth',
        ),
      ],
    ),
    CategorySection(
      title: 'Goals & Growth',
      categories: [
        AffirmationCategory(
          id: 'success',
          name: 'Success',
          icon: Icons.trending_up_rounded,
          color: Color(0xFF2196F3),
          description: 'Achieve your goals and dreams',
        ),
        AffirmationCategory(
          id: 'productivity',
          name: 'Productivity',
          icon: Icons.bolt_rounded,
          color: Color(0xFFFFC107),
          description: 'Get things done efficiently',
        ),
        AffirmationCategory(
          id: 'abundance',
          name: 'Abundance',
          icon: Icons.diamond_rounded,
          color: Color(0xFFFFD700),
          description: 'Attract prosperity and wealth',
        ),
        AffirmationCategory(
          id: 'motivation',
          name: 'Motivation',
          icon: Icons.rocket_launch_rounded,
          color: Color(0xFFFF5722),
          description: 'Ignite your inner fire',
        ),
      ],
    ),
    CategorySection(
      title: 'Wellbeing',
      categories: [
        AffirmationCategory(
          id: 'health',
          name: 'Health',
          icon: Icons.health_and_safety_rounded,
          color: Color(0xFF00BCD4),
          description: 'Nurture your mind and body',
        ),
        AffirmationCategory(
          id: 'peace',
          name: 'Inner Peace',
          icon: Icons.spa_rounded,
          color: Color(0xFF607D8B),
          description: 'Find calm and tranquility',
        ),
        AffirmationCategory(
          id: 'anxiety_relief',
          name: 'Relief',
          icon: Icons.air_rounded,
          color: Color(0xFF81C784),
          description: 'Release worry and stress',
        ),
        AffirmationCategory(
          id: 'sleep',
          name: 'Sleep',
          icon: Icons.bedtime_rounded,
          color: Color(0xFF3F51B5),
          description: 'Prepare for restful sleep',
        ),
      ],
    ),
    CategorySection(
      title: 'Mind & Connection',
      categories: [
        AffirmationCategory(
          id: 'relationships',
          name: 'Relationships',
          icon: Icons.people_rounded,
          color: Color(0xFF9C27B0),
          description: 'Strengthen your connections',
        ),
        AffirmationCategory(
          id: 'focus',
          name: 'Focus',
          icon: Icons.center_focus_strong_rounded,
          color: Color(0xFF795548),
          description: 'Clarity and concentration',
        ),
        AffirmationCategory(
          id: 'resilience',
          name: 'Resilience',
          icon: Icons.shield_rounded,
          color: Color(0xFFF44336),
          description: 'Bounce back from adversity',
        ),
        AffirmationCategory(
          id: 'forgiveness',
          name: 'Forgiveness',
          icon: Icons.volunteer_activism_rounded,
          color: Color(0xFF8BC34A),
          description: 'Let go and find closure',
        ),
      ],
    ),
  ];

  static List<AffirmationCategory> get all =>
      sections.expand((s) => s.categories).toList();

  static AffirmationCategory? getById(String id) {
    try {
      return all.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }
}
