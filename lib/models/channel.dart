import 'package:tv_streaming/models/program.dart';

import 'category.dart';

class Channel {
    int id;
    String name;
    String number;
    String stream;
    String image;
    bool flag_movil;
    String description;
    Category category;
    String categoryId;
    String categoryName;
    List<Program> programs;
    DateTime createdAt;
    DateTime updatedAt;

    Channel({
        this.id,
        this.name,
        this.number,
        this.stream,
        this.image,
        this.description,
        this.category,
        this.categoryId,
        this.categoryName,
        this.programs,
        this.createdAt,
        this.updatedAt,
        this.flag_movil
    });

  void setPrograms(List<Program> programsInput) {
    programs = programsInput;
  }

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
      id: json["id"],
      name: json["name"],
      number: json["number"],
      stream: json["stream"],
      image: json["image"],
      flag_movil: json["flag_movil"],
      
      description: json["description"],
      category: Category.fromJson(json["category"]),
      categoryId: json["category__id"],
      categoryName: json["category__name"],
      programs: json["programs"] != []
          ? json["programs"].map<Program>((item) {            
              // if (item['duration'] > 0)
                return Program(
                  id: item['id'],
                  title: item['title'],
                  date: DateTime.parse(item['date']),
                  season: item['season'],
                  episode: item['episode'],
                  channel: item['channel'],
                  gender: item['gender'],
                  timezone: item['timezone'],
                  createdAt: item['created_at'],
                  updatedAt: item['updated_at'],
                  dateStart: DateTime.parse(item['date_start']),
                  dateEnd: DateTime.parse(item['date_end']),
                );
              // return null;
            }).toList()
          : [],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
  );

  
  String toString() => '($name, $number, $id, $stream,$flag_movil)';

  // toJson() {}
}
