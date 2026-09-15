class ReviewModel {
  final int id;
  final int hotelId;
  final int userId;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.hotelId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      hotelId: json['hotel_id'] is int ? json['hotel_id'] : int.parse(json['hotel_id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
      userName: json['user_name'] ?? 'Khách hàng',
      userAvatar: json['user_avatar'],
      rating: json['rating'] is int ? json['rating'] : int.parse(json['rating'].toString()),
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
