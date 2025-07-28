class Deck {
  final String id;
  final String name;
  final String description;
  final int cardCount;
  final DateTime? createdAt;
  final DateTime? lastAccessed;

  Deck({
    required this.id,
    required this.name,
    required this.description,
    required this.cardCount,
    this.createdAt,
    this.lastAccessed,
  });

  Deck copyWith({
    String? id,
    String? name,
    String? description,
    int? cardCount,
    DateTime? createdAt,
    DateTime? lastAccessed,
  }) {
    return Deck(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cardCount: cardCount ?? this.cardCount,
      createdAt: createdAt ?? this.createdAt,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'cardCount': cardCount,
    'createdAt': createdAt?.toIso8601String(),
    'lastAccessed': lastAccessed?.toIso8601String(),
  };

  factory Deck.fromJson(Map<String, dynamic> json) => Deck(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    cardCount: json['cardCount'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    lastAccessed: json['lastAccessed'] != null ? DateTime.parse(json['lastAccessed']) : null,
  );
}
