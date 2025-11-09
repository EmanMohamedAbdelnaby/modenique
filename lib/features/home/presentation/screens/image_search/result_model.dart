class AiSearchResultModel {
  final int? productId;
  final double? similarityScore;
  final String? itemsImage;
  final String? itemsName;
  final String? itemsDesc;
  final double? itemsPrice;

  AiSearchResultModel({
    this.productId,
    this.similarityScore,
    this.itemsImage,
    this.itemsName,
    this.itemsDesc,
    this.itemsPrice,
  });

  factory AiSearchResultModel.fromJson(Map<String, dynamic> json) {
    return AiSearchResultModel(
      productId: json['product_id'],
      similarityScore: (json['similarity_score'] ?? 0).toDouble(),
      itemsImage: json['itemsImage'],
      itemsName: json['itemsName'],
      itemsDesc: json['itemsDesc'],
      itemsPrice: (json['itemsPrice'] ?? 0).toDouble(),
    );
  }
}
