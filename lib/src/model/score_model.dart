class ScoreModel {

  int id;
  int playerId;
  String playerName;
  String playerImage;
  int score;
  int assistance;
  String createAt;
  String updateAt;
  int interval;
  int status;

  ScoreModel({
    this.id,
    this.playerId,
    this.playerName,
    this.playerImage,
    this.score,
    this.assistance,
    this.createAt,
    this.updateAt,
    this.interval,
    this.status,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) => new ScoreModel(
    id   : int.tryParse( json["id"].toString() ),
    playerId : int.tryParse( json["playerId"].toString() ),
    playerName: json["playerName"].toString(),
    playerImage: json["playerImage"].toString(),
    score: int.tryParse( json["score"].toString() ),
    assistance: int.tryParse( json["assistance"].toString() ),
    createAt: json["create_at"].toString(),
    updateAt: json["update_at"].toString(),
    interval: int.tryParse( json["interval"].toString() ),
    status: int.tryParse( json["status"].toString() ),
  );

  Map<String, dynamic> toJson() => {
    "id"   : id,
    "playerId" : playerId,
    "score": score,
    "assistance": assistance,
    "create_at": createAt,
    "update_at": updateAt,
    "interval": interval,
    "status": status,
  };

  int getScore(){

    double totalAsistence = assistance / 3;

    return score - totalAsistence.toInt();

  }


}