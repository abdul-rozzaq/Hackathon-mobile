import 'package:hackathon/models/floor.dart';
import 'package:hackathon/models/property_image.dart';

class Property {
  final int id;
  final String name;
  final String mainImage;
  final String description;
  final String status;
  final double latitude;
  final double longitude;
  final List<Floor> floors;
  final List<PropertyImage> images;
  final String address;

  Property({
    required this.id,
    required this.name,
    required this.mainImage,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.floors,
    required this.images,
    required this.address,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      mainImage: json['main_image'],
      description: json['description'],
      status: json['status'],
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      floors: (json['floors'] as List).map((floor) => Floor.fromJson(floor)).toList(),
      images: (json['images'] as List).map((image) => PropertyImage.fromJson(image)).toList(),
    );
  }
}
