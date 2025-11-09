class ProductModels {
  String? id;
  String? productCode;
  String? name;
  String? description;
  String? arabicName;
  String? arabicDescription;
  String? coverPictureUrl;
  Null productPictures;
  double? price;
  int? stock;
  double? weight;
  String? color;
  double? rating;
  int? reviewsCount;
  int? discountPercentage;
  String? sellerId;
  List<String>? categories;

  ProductModels(
      {this.id,
      this.productCode,
      this.name,
      this.description,
      this.arabicName,
      this.arabicDescription,
      this.coverPictureUrl,
      this.productPictures,
      this.price,
      this.stock,
      this.weight,
      this.color,
      this.rating,
      this.reviewsCount,
      this.discountPercentage,
      this.sellerId,
      this.categories});

  ProductModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    name = json['name'];
    description = json['description'];
    arabicName = json['"nameArabic"'];
    arabicDescription = json['descriptionArabic'];
    coverPictureUrl = json['coverPictureUrl'];
    productPictures = json['productPictures'];

    price = (json['price'] != null) ? (json['price'] as num).toDouble() : null;
    stock = json['stock'] != null ? json['stock'] as int : null;
    weight =
        (json['weight'] != null) ? (json['weight'] as num).toDouble() : null;
    rating =
        (json['rating'] != null) ? (json['rating'] as num).toDouble() : null;

    color = json['color'];
    reviewsCount = json['reviewsCount'];
    discountPercentage = json['discountPercentage'];
    sellerId = json['sellerId'];
    categories = (json['categories'] != null)
        ? List<String>.from(json['categories'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productCode'] = productCode;
    data['name'] = name;
    data['description'] = description;
    data['nameArabic'] = arabicName;
    data['descriptionArabic'] = arabicDescription;
    data['coverPictureUrl'] = coverPictureUrl;
    data['productPictures'] = productPictures;
    data['price'] = price;
    data['stock'] = stock;
    data['weight'] = weight;
    data['color'] = color;
    data['rating'] = rating;
    data['reviewsCount'] = reviewsCount;
    data['discountPercentage'] = discountPercentage;
    data['sellerId'] = sellerId;
    data['categories'] = categories;
    return data;
  }
}
