import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hackathon/core/colors.dart';
import 'package:hackathon/models/property.dart';
import '../screens/properties/property_details_screen.dart';

class CustomPropertyCard extends StatelessWidget {
  final Property property;

  const CustomPropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    int minPrice = property.floors.expand((floor) => floor.apartments).map((apartment) => apartment.price).reduce((a, b) => a < b ? a : b);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyDetailsScreen(property: property),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: CachedNetworkImage(
                imageUrl: property.mainImage,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Color(0xFFFF7F50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Narx: $minPrice so\'m',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Holat: ${property.status}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
