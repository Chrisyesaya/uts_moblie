// models/membership.dart
class Membership {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration; // dalam bulan
  final String image;
  final List<String> benefits;
  final String category;

  Membership({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.image,
    required this.benefits,
    required this.category,
  });
}