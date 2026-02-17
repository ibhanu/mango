/// Affirmation data model
class Affirmation {
  final String id;
  final String text;
  final String categoryId;
  bool isFavorite;
  DateTime? lastShown;

  Affirmation({
    required this.id,
    required this.text,
    required this.categoryId,
    this.isFavorite = false,
    this.lastShown,
  });

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      id: json['id'] as String,
      text: json['text'] as String,
      categoryId: json['categoryId'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastShown: json['lastShown'] != null
          ? DateTime.parse(json['lastShown'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'categoryId': categoryId,
      'isFavorite': isFavorite,
      'lastShown': lastShown?.toIso8601String(),
    };
  }

  Affirmation copyWith({
    String? id,
    String? text,
    String? categoryId,
    bool? isFavorite,
    DateTime? lastShown,
  }) {
    return Affirmation(
      id: id ?? this.id,
      text: text ?? this.text,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      lastShown: lastShown ?? this.lastShown,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Affirmation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
