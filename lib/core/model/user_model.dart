class UserModel {

  UserModel({
    required this.uid,
    this.imageFilePath,
    this.name,
    required this.createdAt,
    this.updatedAt,
  });

  final String uid;
  String? imageFilePath;
  String? name;
  final String createdAt;
  String? updatedAt;


  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'] as String,
        imageFilePath: json['image_file_path'] as String?,
        name: json['name'] as String?,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'image_file_path': imageFilePath,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }

  UserModel copyWith({String? name, String? imageFilePath}) {
    return UserModel(
      uid: uid,
      name: name ?? name,
      imageFilePath: imageFilePath ?? imageFilePath,
      createdAt: createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

}