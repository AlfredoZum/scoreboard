class ScoreModel {

  int id;
  int playerId;
  int score;
  String date;
  int interval;
  int status;

  ScoreModel({
    this.id,
    this.playerId,
    this.score,
    this.date,
    this.interval,
    this.status,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) => new ScoreModel(
    id   : json["id"],
    playerId : json["playerId"],
    score: json["score"],
    date: json["date"],
    interval: json["interval"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id"   : id,
    "playerId" : playerId,
    "score": score,
    "date": date,
    "interval": interval,
    "status": status,
  };


}