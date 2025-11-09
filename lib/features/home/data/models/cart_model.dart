class CartModel {
  final String cartId;
  final List<CartItem> cartItems;
  final double couponDiscount; // خصم الكوبون

  CartModel({
    required this.cartId,
    required this.cartItems,
    this.couponDiscount = 0.0, // القيمة الافتراضية 0.0
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'] ?? '',
      cartItems: (json['cartItems'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      couponDiscount: (json['couponDiscount'] ?? 0).toDouble(),
    );
  }

  double get subtotal {
    double sum = 0;
    for (var item in cartItems) {
      sum += item.finalPricePerUnit * item.quantity;
    }
    return sum;
  }

  double get total {
    const double shipping = 25.0;
    return subtotal + shipping - couponDiscount;
  }
}

class CartItem {
  final String itemId;
  final String productId;
  final String productName;
  final String productCoverUrl;
  final int productStock;
  final int quantity;
  final double basePricePerUnit;
  final double finalPricePerUnit;
  final double totalPrice;
  final int discountPercentage;

  CartItem({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.productCoverUrl,
    required this.productStock,
    required this.quantity,
    required this.basePricePerUnit,
    required this.finalPricePerUnit,
    required this.totalPrice,
    required this.discountPercentage,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    double basePrice = (json['basePricePerUnit'] ?? 0).toDouble();
    int discountPerc = json['discountPercentage'] ?? 0;
    double finalPrice = (json['finalPricePerUnit'] ?? basePrice).toDouble();
    int quantity = json['quantity'] ?? 0;

    return CartItem(
      itemId: json['itemId'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productCoverUrl: json['productCoverUrl'] ?? '',
      productStock: json['productStock'] ?? 0,
      quantity: quantity,
      basePricePerUnit: basePrice,
      discountPercentage: discountPerc,
      finalPricePerUnit: finalPrice,
      totalPrice: finalPrice * quantity,
    );
  }
}
