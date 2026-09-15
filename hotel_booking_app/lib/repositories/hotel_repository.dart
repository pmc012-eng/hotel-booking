import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../models/hotel_model.dart';
import '../models/review_model.dart';

class HotelRepository {
  final ApiClient _client;

  HotelRepository({ApiClient? client}) : _client = client ?? apiClient;

  /// Lấy danh sách khách sạn có lọc, tìm kiếm và phân trang
  Future<List<HotelModel>> getHotels({
    String? search,
    String? city,
    int? star,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (search != null && search.trim().isNotEmpty) queryParams['search'] = search.trim();
    if (city != null && city != 'Tất cả' && city.trim().isNotEmpty) queryParams['city'] = city.trim();
    if (star != null) queryParams['star'] = star;
    if (minPrice != null) queryParams['minPrice'] = minPrice;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
    if (sortBy != null) queryParams['sortBy'] = sortBy;

    final response = await _client.get(ApiEndpoints.hotels, queryParameters: queryParams);
    final list = response.data['data'] as List;
    return list.map((item) => HotelModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Lấy danh sách khách sạn nổi bật
  Future<List<HotelModel>> getFeaturedHotels({int limit = 6}) async {
    final response = await _client.get(
      ApiEndpoints.featuredHotels,
      queryParameters: {'limit': limit},
    );
    final list = response.data['data'] as List;
    return list.map((item) => HotelModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Lấy thông tin chi tiết khách sạn
  Future<HotelModel> getHotelById(int id) async {
    final response = await _client.get(ApiEndpoints.hotelDetail(id));
    final data = response.data['data'] as Map<String, dynamic>;
    return HotelModel.fromJson(data);
  }

  /// Lấy danh sách đánh giá của khách sạn
  Future<List<ReviewModel>> getHotelReviews(int hotelId) async {
    final response = await _client.get(ApiEndpoints.hotelReviews(hotelId));
    final list = response.data['data'] as List;
    return list.map((item) => ReviewModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Đăng đánh giá mới
  Future<ReviewModel> createReview(int hotelId, int rating, String comment) async {
    final response = await _client.post(
      ApiEndpoints.hotelReviews(hotelId),
      data: {
        'rating': rating,
        'comment': comment,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ReviewModel.fromJson(data);
  }
}

final hotelRepository = HotelRepository();
