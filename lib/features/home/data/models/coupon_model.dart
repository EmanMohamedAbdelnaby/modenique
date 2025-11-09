class CouponModel {
  final String id;
  final String couponCode;
  final String couponType;
  final double discountValue;
  final double maxDiscount;
  final String expiresAt;

  CouponModel({
    required this.id,
    required this.couponCode,
    required this.couponType,
    required this.discountValue,
    required this.maxDiscount,
    required this.expiresAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] ?? '',
      couponCode: json['couponCode'] ?? '',
      couponType: json['couponType'] ?? '',
      discountValue:
          double.tryParse(json['discountValue'].toString()) ?? 0.0,
      maxDiscount:
          double.tryParse(json['maxDiscount'].toString()) ?? 0.0,
      expiresAt: json['expiresAt'] ?? '',
    );
  }
}
