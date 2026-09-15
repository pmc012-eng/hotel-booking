import '../core/constants/app_constants.dart';
import 'room_model.dart';

class HotelModel {
  final int id;
  final String name;
  final String? description;
  final String address;
  final String city;
  final int star;
  final double rating;
  final String? primaryImage;
  final double minPrice;
  final int reviewCount;
  final List<String> images;
  final List<RoomTypeModel> roomTypes;

  HotelModel({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.city,
    this.star = 4,
    this.rating = 4.5,
    this.primaryImage,
    this.minPrice = 0.0,
    this.reviewCount = 0,
    this.images = const [],
    this.roomTypes = const [],
  });

  /// Trả về đường dẫn ảnh đầy đủ (tương thích backend localhost/10.0.2.2 hoặc URL ngoài)
  String get fullPrimaryImageUrl {
    if (primaryImage == null || primaryImage!.trim().isEmpty) {
      return 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80';
    }
    final trimmed = primaryImage!.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return '${AppConstants.imageBaseUrl}$trimmed';
  }

  List<String> get fullImageUrls {
    final validImages = images.where((img) => img.trim().isNotEmpty).toList();
    if (validImages.isEmpty) {
      return [fullPrimaryImageUrl];
    }
    return validImages.map((img) {
      final trimmed = img.trim();
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        return trimmed;
      }
      return '${AppConstants.imageBaseUrl}$trimmed';
    }).toList();
  }

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    List<String> imgs = [];
    if (json['images'] is List) {
      imgs = (json['images'] as List)
          .where((x) => x != null && x.toString().trim().isNotEmpty)
          .map((x) => x.toString().trim())
          .toList();
    }

    List<RoomTypeModel> rts = [];
    if (json['roomTypes'] is List) {
      rts = (json['roomTypes'] as List)
          .whereType<Map<String, dynamic>>()
          .map((x) => RoomTypeModel.fromJson(x))
          .toList();
    }

    return HotelModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      star: json['star'] != null
          ? (json['star'] is int ? json['star'] : int.tryParse(json['star'].toString()) ?? 4)
          : 4,
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
      primaryImage: json['primary_image']?.toString(),
      minPrice: double.tryParse(json['min_price']?.toString() ?? '0') ?? 0.0,
      reviewCount: json['review_count'] != null
          ? (json['review_count'] is int ? json['review_count'] : int.tryParse(json['review_count'].toString()) ?? 0)
          : 0,
      images: imgs,
      roomTypes: rts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'star': star,
      'rating': rating,
      'primary_image': primaryImage,
      'min_price': minPrice,
      'review_count': reviewCount,
      'images': images,
      'roomTypes': roomTypes.map((x) => x.toJson()).toList(),
    };
  }
}
