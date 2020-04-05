import 'dart:io';

class PlayerModel {

  int id;
  String name;
  String image;
  File fileImage;

  PlayerModel({
    this.id,
    this.name,
    this.image,
    this.fileImage,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => new PlayerModel(
    id   : json["id"],
    name : json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id"   : id,
    "name" : name,
    "image": image,
  };

}