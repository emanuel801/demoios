class Category {
    int id;
    String name;
    dynamic order;
    String image;
    bool flagAdult;
    bool flagAvailable;
    DateTime createdAt;
    DateTime updatedAt;

    Category({
        this.id,
        this.name,
        this.order,
        this.image,
        this.flagAdult,
        this.flagAvailable,
        this.createdAt,
        this.updatedAt,
    });


    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        order: json["order"],
        image: json["image"],
        flagAdult: json["flag_adult"],
        flagAvailable: json["flag_available"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );
  String toString() => '($image)';

  toJson() {}
}
