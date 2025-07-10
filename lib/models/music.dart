class Music {
  final String title;
  final String thumbnail;
  final String url;
  final String uploader;

  const Music({
    required this.title,
    required this.thumbnail,
    required this.url,
    required this.uploader,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['title'],
      thumbnail: json['thumbnail'],
      url: json['url'],
      uploader: json['uploaderName'],
    );
  }
}
