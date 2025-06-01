class Apartment {
  final int id;
  final int floorId;
  final bool isDone;
  final int roomsNumber;
  final double area;
  final int price;
  final int depositFee;
  final int? boughtBy;
  final String image;

  Apartment({
    required this.id,
    required this.floorId,
    required this.isDone,
    required this.roomsNumber,
    required this.area,
    required this.price,
    required this.depositFee,
    required this.image,
    this.boughtBy,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'],
      floorId: json['floor'],
      isDone: json['is_done'],
      roomsNumber: json['rooms_number'],
      area: json['area'].toDouble(),
      price: json['price'],
      depositFee: json['deposit_fee'],
      boughtBy: json['bought_by'],
      image: json['image'],
    );
  }
}
