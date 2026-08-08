class CreateReviewRequestModel {
  final int rating;
  final String comment;

  CreateReviewRequestModel({required this.rating, required this.comment});

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "comment": comment,
      };
}