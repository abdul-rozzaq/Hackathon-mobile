import 'package:hackathon/models/apartment.dart';

class Floor {
  final int id;
  final int floorNumber;
  final int propertyId;
  final String imageUrl;
  final String createdAt;
  final int updatedAt;
  final List<Apartment> apartments;

  Floor({
    required this.id,
    required this.floorNumber,
    required this.propertyId,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.apartments,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'],
      floorNumber: json['floor_number'],
      propertyId: json['property'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      apartments: (json['apartments'] as List).map((apartment) => Apartment.fromJson(apartment)).toList(),
    );
  }
}
