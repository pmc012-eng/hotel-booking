import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/hotel_model.dart';
import '../models/review_model.dart';
import '../repositories/hotel_repository.dart';

final hotelRepositoryProvider = Provider<HotelRepository>((ref) {
  return hotelRepository;
});

/// Danh sách khách sạn nổi bật trang chủ
final featuredHotelsProvider = FutureProvider<List<HotelModel>>((ref) async {
  final repo = ref.watch(hotelRepositoryProvider);
  return repo.getFeaturedHotels(limit: 6);
});

/// Tất cả khách sạn
final allHotelsProvider = FutureProvider<List<HotelModel>>((ref) async {
  final repo = ref.watch(hotelRepositoryProvider);
  return repo.getHotels(limit: 20);
});

/// Chi tiết khách sạn theo ID
final hotelDetailProvider = FutureProvider.family<HotelModel, int>((ref, id) async {
  final repo = ref.watch(hotelRepositoryProvider);
  return repo.getHotelById(id);
});

/// Đánh giá của khách sạn theo hotelId
final hotelReviewsProvider = FutureProvider.family<List<ReviewModel>, int>((ref, hotelId) async {
  final repo = ref.watch(hotelRepositoryProvider);
  return repo.getHotelReviews(hotelId);
});

/// Model bộ lọc tìm kiếm
class HotelFilterState {
  final String search;
  final String city;
  final int? star;
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy;

  const HotelFilterState({
    this.search = '',
    this.city = 'Tất cả',
    this.star,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
  });

  HotelFilterState copyWith({
    String? search,
    String? city,
    int? star,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool clearStar = false,
  }) {
    return HotelFilterState(
      search: search ?? this.search,
      city: city ?? this.city,
      star: clearStar ? null : (star ?? this.star),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HotelFilterState &&
          runtimeType == other.runtimeType &&
          search == other.search &&
          city == other.city &&
          star == other.star &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          sortBy == other.sortBy;

  @override
  int get hashCode =>
      search.hashCode ^
      city.hashCode ^
      star.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode ^
      sortBy.hashCode;
}

final hotelFilterProvider = StateProvider<HotelFilterState>((ref) {
  return const HotelFilterState();
});

/// Lấy danh sách khách sạn theo bộ lọc hiện tại
final searchHotelsProvider = FutureProvider<List<HotelModel>>((ref) async {
  final repo = ref.watch(hotelRepositoryProvider);
  final filter = ref.watch(hotelFilterProvider);

  return repo.getHotels(
    search: filter.search.isNotEmpty ? filter.search : null,
    city: filter.city != 'Tất cả' ? filter.city : null,
    star: filter.star,
    minPrice: filter.minPrice,
    maxPrice: filter.maxPrice,
    sortBy: filter.sortBy,
  );
});
