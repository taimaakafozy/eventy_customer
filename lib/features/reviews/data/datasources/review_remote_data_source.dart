import 'package:dio/dio.dart';
import 'package:eventy_customer/core/network/dio_error_mapper.dart';

import '../../../../core/network/dio_client.dart';
import '../models/create_review_request_model.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<ReviewModel> createReview(String bookingId, CreateReviewRequestModel request);

  Future<ReviewsListResponseModel> getServiceReviews(
    String serviceId, {
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  });

  /// ⚠️ يرجع null إذا لم يقيّم المستخدم هذا الحجز بعد (السيرفر يرجع 404 بهذه الحالة)
  Future<ReviewModel?> getMyReview(String bookingId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final DioClient client;

  ReviewRemoteDataSourceImpl(this.client);

  @override
  Future<ReviewModel> createReview(String bookingId, CreateReviewRequestModel request) async {
    try {
      final response = await client.dio.post('bookings/$bookingId/review', data: request.toJson());
      final data = response.data;

      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to submit review');
      }

      return ReviewModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e, fallback: "Failed to submit your review. Please try again.");
    }
  }

  @override
  Future<ReviewsListResponseModel> getServiceReviews(
    String serviceId, {
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  }) async {
    try {
      final response = await client.dio.get(
        'services/$serviceId/reviews',
        queryParameters: {'page': page, 'limit': limit, 'sortBy': sortBy, 'order': order},
      );
      final data = response.data;

      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to load reviews');
      }

      return ReviewsListResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e, fallback: "Failed to load reviews.");
    }
  }

  @override
  Future<ReviewModel?> getMyReview(String bookingId) async {
    try {
      final response = await client.dio.get('bookings/$bookingId/review');
      final data = response.data;

      if (data['success'] != true) return null;

      return ReviewModel.fromJson(data['data']);
    } on DioException catch (e) {
      /// ⚠️ 404 هنا يعني ببساطة "لم يُقيَّم بعد" — ليس خطأً فعليًا
      if (e.response?.statusCode == 404) return null;
      throw DioErrorMapper.map(e, fallback: "Failed to load your review.");
    }
  }
}