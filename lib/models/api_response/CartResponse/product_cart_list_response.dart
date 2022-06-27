class ProductCartListResponse {
  List<ProductCartListResponseDetails> details;
  int totalCount;

  ProductCartListResponse({this.details, this.totalCount});

  ProductCartListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductCartListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class ProductCartListResponseDetails {
  int pkID;
  int customerID;
  int productID;
  String productName;
  String unit;
  double quantity;
  double unitPrice;
  double discountPercent;
  String productImage;
  String productGroupName;
  String productGroupImage;
  String brandName;
  String brandImage;
  double Vat;

  ProductCartListResponseDetails(
      {this.pkID,
      this.customerID,
      this.productID,
      this.productName,
      this.unit,
      this.quantity,
      this.unitPrice,
      this.discountPercent,
      this.productImage,
      this.productGroupName,
      this.productGroupImage,
      this.brandName,
      this.brandImage,
      this.Vat});

  ProductCartListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    quantity = json['Quantity'] == null ? 0.00 : json['Quantity'];
    unitPrice = json['UnitPrice'] == null ? 0.00 : json['UnitPrice'];
    discountPercent =
        json['DiscountPercent'] == null ? 0.00 : json['DiscountPercent'];
    productImage = json['ProductImage'] == null ? "" : json['ProductImage'];
    productGroupName =
        json['ProductGroupName'] == null ? "" : json['ProductGroupName'];
    productGroupImage =
        json['ProductGroupImage'] == null ? "" : json['ProductGroupImage'];
    brandName = json['BrandName'] == null ? "" : json['BrandName'];
    brandImage = json['BrandImage'] == null ? "" : json['BrandImage'];
    Vat = json['Vat'] == null ? 0.00 : json['Vat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CustomerID'] = this.customerID;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['Unit'] = this.unit;
    data['Quantity'] = this.quantity;
    data['UnitPrice'] = this.unitPrice;
    data['DiscountPercent'] = this.discountPercent;
    data['ProductImage'] = this.productImage;
    data['ProductGroupName'] = this.productGroupName;
    data['ProductGroupImage'] = this.productGroupImage;
    data['BrandName'] = this.brandName;
    data['BrandImage'] = this.brandImage;
    data['Vat'] = this.Vat;
    return data;
  }
}
