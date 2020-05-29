class GamesPlayedModel {

  int id;
  int gamesId;
  String createAt;
  String updateAt;
  int status;

  GamesPlayedModel({
    this.id,
    this.gamesId,
    this.createAt,
    this.updateAt,
    this.status,
  });

  factory GamesPlayedModel.fromJson(Map<String, dynamic> json) => new GamesPlayedModel(
    id   : int.tryParse( json["id"].toString() ),
    gamesId: int.tryParse( json["gamesId"].toString() ),
    createAt: json["create_at"].toString(),
    updateAt: json["update_at"].toString(),
    status: int.tryParse( json["status"].toString() ),
  );

  Map<String, dynamic> toJson() => {
    "id"   : id,
    "gamesId" : gamesId,
    "create_at": createAt,
    "update_at": updateAt,
    "status": status,
  };

}