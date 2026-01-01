class Yoga {
  String? id;
  String? category;
  String? subCategory;
  String? title;
  String? videoLink;
  String? img;
  String? popular;
  String? weightLoss;

  Yoga({
    this.id,
    this.category,
    this.subCategory,
    this.title,
    this.videoLink,
    this.img,
    this.popular,
    this.weightLoss,
  });

  Yoga.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    category = json["category"];
    subCategory = json["sub_category"];
    title = json["title"];

    // 🔥 IMPORTANT FIX — support both video_link & videoLink
    videoLink = json["video_link"] ?? json["videoLink"];

    img = json["img"];
    popular = json["popular"];
    weightLoss = json["weight_loss"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["category"] = category;
    data["sub_category"] = subCategory;
    data["title"] = title;

    // 🔥 Always save using videoLink key
    data["videoLink"] = videoLink;

    data["img"] = img;
    data["popular"] = popular;
    data["weight_loss"] = weightLoss;
    return data;
  }

  static List<Yoga> ofdata(List data) {
    return data.map((e) => Yoga.fromJson(e)).toList();
  }
}
