class RoomTypeModel {
  final int id;
  final int hotelId;
  final String name;
  final String? description;
  final int capacity;
  final double price;
  final String? imageUrl;
  final List<String> amenities;

  RoomTypeModel({
    required this.id,
    required this.hotelId,
    required this.name,
    this.description,
    required this.capacity,
    required this.price,
    this.imageUrl,
    this.amenities = const [],
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    List<String> amenitiesList = [];
    if (json['amenities'] is List) {
      amenitiesList = List<String>.from(json['amenities'].map((x) => x.toString()));
    }

    return RoomTypeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      hotelId: json['hotel_id'] != null
          ? (json['hotel_id'] is int ? json['hotel_id'] : int.tryParse(json['hotel_id']?.toString() ?? '0') ?? 0)
          : 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      capacity: json['capacity'] is int
          ? json['capacity']
          : int.tryParse(json['capacity']?.toString() ?? '2') ?? 2,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: json['image_url']?.toString(),
      amenities: amenitiesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'name': name,
      'description': description,
      'capacity': capacity,
      'price': price,
      'image_url': imageUrl,
      'amenities': amenities,
    };
  }
}

class RoomModel {
  final int id;
  final int hotelId;
  final int roomTypeId;
  final String roomNumber;
  final String status;
  final String? roomTypeName;
  final String? roomTypeDescription;
  final int capacity;
  final double price;
  final String? imageUrl;
  final List<String> amenities;
  final String? hotelName;
  final String? hotelAddress;
  final String? hotelCity;

  RoomModel({
    required this.id,
    required this.hotelId,
    required this.roomTypeId,
    required this.roomNumber,
    required this.status,
    this.roomTypeName,
    this.roomTypeDescription,
    this.capacity = 2,
    this.price = 0.0,
    this.imageUrl,
    this.amenities = const [],
    this.hotelName,
    this.hotelAddress,
    this.hotelCity,
  });

  bool get isAvailable => status == 'AVAILABLE';

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    List<String> amenitiesList = [];
    if (json['amenities'] is List) {
      amenitiesList = List<String>.from(json['amenities'].map((x) => x.toString()));
    }

    return RoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      hotelId: json['hotel_id'] is int ? json['hotel_id'] : int.tryParse(json['hotel_id']?.toString() ?? '0') ?? 0,
      roomTypeId: json['room_type_id'] is int
          ? json['room_type_id']
          : int.tryParse(json['room_type_id']?.toString() ?? '0') ?? 0,
      roomNumber: json['room_number']?.toString() ?? '',
      status: json['status']?.toString() ?? 'AVAILABLE',
      roomTypeName: json['room_type_name']?.toString(),
      roomTypeDescription: json['room_type_description']?.toString(),
      capacity: json['capacity'] != null
          ? (json['capacity'] is int ? json['capacity'] : int.tryParse(json['capacity'].toString()) ?? 2)
          : 2,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: json['image_url']?.toString(),
      amenities: amenitiesList,
      hotelName: json['hotel_name']?.toString(),
      hotelAddress: json['hotel_address']?.toString(),
      hotelCity: json['hotel_city']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'room_type_id': roomTypeId,
      'room_number': roomNumber,
      'status': status,
      'room_type_name': roomTypeName,
      'room_type_description': roomTypeDescription,
      'capacity': capacity,
      'price': price,
      'image_url': imageUrl,
      'amenities': amenities,
      'hotel_name': hotelName,
      'hotel_address': hotelAddress,
      'hotel_city': hotelCity,
    };
  }
}
