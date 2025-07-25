class HomeUserModel {
  final String id;
  final String name;
  final String profile;
  final bool isDeleted;

  HomeUserModel({
    required this.id,
    required this.name,
    required this.profile,
    required this.isDeleted,
  });

  factory HomeUserModel.fromJson(Map<String, dynamic> json) => HomeUserModel(
    id: json["_id"],
    name: json["name"],
    profile: json["profile"] ?? "",
    isDeleted: json["isDeleted"] ?? false,
  );
}
