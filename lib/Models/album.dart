class Album {
  final List<dynamic> daily;
  final List<dynamic> hourly;

  Album({this.daily, this.hourly});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      daily: json['daily'],
      hourly: json['hourly'],
    );
  }
}
