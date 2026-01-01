class Meditation {
  String? id;
  String? category;
  String? title;
  String? videoLink;
  String? img;

  Meditation({this.id, this.category, this.title, this.videoLink, this.img});

  Meditation.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    category = json["category"];
    title = json["title"];
    videoLink = json["video_link"];
    img = json["img"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["category"] = category;
    _data["title"] = title;
    _data["video_link"] = videoLink;
    _data["img"] = img;
    return _data;
  }

  static List<Meditation> ofdata(List data) {
    return data.map((e) => Meditation.fromJson(e)).toList();
  }
}
