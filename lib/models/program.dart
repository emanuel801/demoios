// To parse this JSON data, do
//
//     final program = programFromJson(jsonString);

// import 'dart:convert';

// List<Program> programFromJson(String str) => List<Program>.from(json.decode(str).map((x) => Program.fromJson(x)));

// String programToJson(List<Program> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Program {
    Program({
        this.id,
        this.title,
        this.date,
        this.dateStart,
        this.dateEnd,
        this.season,
        this.episode,
        this.channel,
        this.gender,
        this.timezone,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String title;
    DateTime date;
    DateTime dateStart;
    DateTime dateEnd;
    String season;
    String episode;
    int channel;
    int gender;
    int timezone;
    String createdAt;
    String updatedAt;

  @override
  String toString() {

    return '$title: $dateStart - $dateEnd';
  }
}


