class GameModel {

  int id;
  String name;
  String createAt;
  String updateAt;
  int status;

  GameModel({
    this.id,
    this.name,
    this.createAt,
    this.updateAt,
    this.status,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) => new GameModel(
    id   : int.tryParse( json["id"].toString() ),
    name: json["name"].toString(),
    createAt: json["create_at"].toString(),
    updateAt: json["update_at"].toString(),
    status: int.tryParse( json["status"].toString() ),
  );

  Map<String, dynamic> toJson() => {
    "id"   : id,
    "name" : name,
    "create_at": createAt,
    "update_at": updateAt,
    "status": status,
  };

}