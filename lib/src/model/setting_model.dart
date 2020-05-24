class SettingModel {

  int id;
  int firstTime;

  SettingModel({
    this.id,
    this.firstTime,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => new SettingModel(
    id   : int.tryParse( json["id"].toString() ),
    firstTime : int.tryParse( json["firstTime"].toString() ),
  );

  Map<String, dynamic> toJson() => {
    "id"   : id,
    "firstTime" : firstTime,
  };

}