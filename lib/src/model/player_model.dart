import 'dart:io';

class PlayerModel {

  int id;
  String name;
  String image;
  File fileImage;
  String createAt;
  String updateAt;
  int status;

  PlayerModel({
    this.id,
    this.name,
    this.image,
    this.fileImage,
    this.createAt,
    this.updateAt,
    this.status,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => new PlayerModel(
    id   : int.tryParse( json["id"].toString() ),
    name : json["name"].toString(),
    image: json["image"].toString(),
    createAt: json["create_at"].toString(),
    updateAt: json["update_at"].toString(),
    status: int.tryParse( json["status"].toString() ),
  );

  Map<String, dynamic> toJson() => {
    "id"   : id,
    "name" : name,
    "image": image,
    "create_at": createAt,
    "update_at": updateAt,
    "status": status,
  };

}