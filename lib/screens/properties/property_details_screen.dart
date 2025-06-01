import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hackathon/core/colors.dart';
import 'package:hackathon/models/apartment.dart';
import 'package:hackathon/models/floor.dart';
import 'package:hackathon/models/property.dart';
import 'package:hackathon/screens/contract/create_contract_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  PropertyDetailsScreenState createState() => PropertyDetailsScreenState();
}

class PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  Floor? _selectedFloor;
  Apartment? _selectedRoom;
  int _currentIndex = 0;

  final _borderRadius = BorderRadius.circular(12.0);
  final _backgroundIndigo = AppColors.primaryColor.withOpacity(0.1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uy Tafsilotlari')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: _selectedRoom != null
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateContractScreen(
                        apartment: _selectedRoom!,
                      ),
                    ),
                  )
              : null,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: _selectedRoom != null ? AppColors.primaryColor : Colors.grey[300],
              borderRadius: _borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Shartnoma Yaratish',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: widget.property.images.map((img) {
                      return ClipRRect(
                        borderRadius: _borderRadius,
                        child: CachedNetworkImage(
                          imageUrl: img.imageUrl,
                          placeholder: (context, url) => const SpinKitFadingCircle(color: AppColors.primaryColor),
                          errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.primaryColor),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.property.images.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor.withOpacity(_currentIndex == entry.key ? 1.0 : 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Umumiy Ma’lumotlar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.location_on,
                    label: 'Manzil',
                    value: widget.property.address,
                  ),
                  const SizedBox(height: 16),
                  // Xarita qo'shildi
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor, width: 2),
                      borderRadius: _borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: _borderRadius,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            widget.property.latitude,
                            widget.property.longitude,
                          ),
                          initialZoom: 13.0,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  widget.property.latitude,
                                  widget.property.longitude,
                                ),
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    icon: Icons.layers,
                    label: 'Qavatlar Soni',
                    value: widget.property.floors.length.toString(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tavsif',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.property.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 45,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: widget.property.floors.length,
                itemBuilder: (context, index) {
                  final floor = widget.property.floors.elementAt(index);

                  return InkWell(
                    borderRadius: _borderRadius,
                    onTap: _selectedFloor == floor
                        ? null
                        : () {
                            setState(() {
                              _selectedFloor = floor;
                              _selectedRoom = null;
                            });
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: _selectedFloor == floor ? AppColors.primaryColor : Colors.white,
                        border: Border.all(color: AppColors.primaryColor, width: 1.5),
                        borderRadius: _borderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${floor.floorNumber}-qavat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedFloor == floor ? Colors.white : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedFloor != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 200),
                      decoration: BoxDecoration(
                        color: _backgroundIndigo,
                        border: Border.all(color: AppColors.primaryColor, width: 2),
                        borderRadius: _borderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: _borderRadius,
                        child: CachedNetworkImage(
                          imageUrl: _selectedRoom != null ? _selectedRoom!.image : _selectedFloor!.imageUrl,
                          placeholder: (context, url) => const SpinKitFadingCircle(color: AppColors.primaryColor),
                          errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.primaryColor),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Uylar:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _selectedFloor!.apartments.map<Widget>((entry) {
                        final isSold = entry.boughtBy != null;

                        return InkWell(
                          borderRadius: _borderRadius,
                          onTap: !isSold ? () => setState(() => _selectedRoom = _selectedRoom == entry ? null : entry) : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: _selectedRoom == entry ? AppColors.primaryColor : Colors.white,
                              border: Border.all(color: isSold ? Colors.red.shade600 : AppColors.primaryColor, width: 1.5),
                              borderRadius: _borderRadius,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '${entry.id}-uy',
                              style: TextStyle(
                                color: isSold
                                    ? Colors.red.shade600
                                    : _selectedRoom == entry
                                        ? Colors.white
                                        : AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedRoom != null)
                      Container(
                        decoration: BoxDecoration(
                          color: _backgroundIndigo.withOpacity(.2),
                          border: Border.all(color: AppColors.primaryColor.withOpacity(.2)),
                          borderRadius: _borderRadius,
                          boxShadow: [],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              icon: Icons.attach_money,
                              label: 'Narx',
                              value: '${_selectedRoom!.price} so\'m',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.build,
                              label: 'Holat',
                              value: _selectedRoom!.isDone ? 'Tugallangan' : 'Tugallanmagan',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.meeting_room,
                              label: 'Xonalar',
                              value: _selectedRoom!.roomsNumber.toString(),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.square_foot,
                              label: 'Umumiy Maydon',
                              value: '${_selectedRoom!.area} m²',
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
