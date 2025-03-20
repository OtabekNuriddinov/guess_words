class GameData {
  final ImageData left;
  final ImageData right;
  final String description;
  final String word;
  final List<String> letters;
  final String imageUrl;
  final int leftLetter;
  final int rightLetter;
  final int middleLetter;
  final int level;
  final int coin;

  GameData({
    required this.left,
    required this.right,
    required this.description,
    required this.word,
    required this.letters,
    required this.imageUrl,
    required this.leftLetter,
    required this.rightLetter,
    required this.middleLetter,
    required this.level,
    required this.coin,
  });

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      left: ImageData.fromJson(json['left']),
      right: ImageData.fromJson(json['right']),
      description: json['description'],
      word: json['word'],
      letters: List<String>.from(json['letters']),
      imageUrl: json['imageUrl'],
      leftLetter: json['leftLetter'],
      rightLetter: json['rightLetter'],
      middleLetter: json['middleLetter'],
      level: json['level'],
      coin: json['coin'],
    );
  }
}

class ImageData {
  final String imageUrl;
  final int color;
  final int length;
  final int fill;
  final String name;

  ImageData({
    required this.imageUrl,
    required this.color,
    required this.length,
    required this.fill,
    required this.name,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      imageUrl: json['imageUrl'],
      color: json['color'],
      length: json['length'],
      fill: json['fill'],
      name: json['name'],
    );
  }
}
