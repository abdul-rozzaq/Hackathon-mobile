class PropertyImage {
  final int id;
  final String imageUrl;

  PropertyImage({
    required this.id,
    required this.imageUrl,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'],
      imageUrl: json['image_url'],
    );
  }
}
