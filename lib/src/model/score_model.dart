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
    id   : json["id"],
    playerId : json["playerId"],
    playerName: json["playerName"],
    playerImage: json["playerImage"],
    score: json["score"],
    assistance: json["assistance"],
    createAt: json["create_at"],
    updateAt: json["update_at"],
    interval: json["interval"],
    status: json["status"],
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