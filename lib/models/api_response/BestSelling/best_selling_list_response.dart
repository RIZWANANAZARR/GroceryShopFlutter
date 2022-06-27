class BestSellingListResponse {
  List<BestSellingListResponseDetails> details;
  int totalCount;

  BestSellingListResponse({this.details, this.totalCount});

  BestSellingListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new BestSellingListResponseDetails.fromJson(v));
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

class BestSellingListResponseDetails {
  int productID;
  String bestSellingProductName;
  double bestSellingQuantity;
  String unit;
  double unitPrice;
  double discountPercent;
  String productSpecification;
  String productImage;
  int productGroupID;
  String productGroupName;
  String productGroupImage;
  int brandID;
  String brandName;
  String brandImage;

  BestSellingListResponseDetails(
      {this.productID,
        this.bestSellingProductName,
        this.bestSellingQuantity,
        this.unit,
        this.unitPrice,
        this.discountPercent,
        this.productSpecification,
        this.productImage,
        this.productGroupID,
        this.productGroupName,
        this.productGroupImage,
        this.brandID,
        this.brandName,
        this.brandImage});

  BestSellingListResponseDetails.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID']==null?0:json['ProductID'];
    bestSellingProductName = json['BestSellingProductName']==null?"":json['BestSellingProductName'];
    bestSellingQuantity = json['BestSellingQuantity']==null?0.00:json['BestSellingQuantity'];
    unit = json['Unit']==null?"":json['Unit'];
    unitPrice = json['UnitPrice']==null?0.00:json['UnitPrice'];
    discountPercent = json['DiscountPercent']==null?0.00:json['DiscountPercent'];
    productSpecification = json['ProductSpecification']==null?"":json['ProductSpecification'];
    productImage = json['ProductImage']==null?"":json['ProductImage'];
    productGroupID = json['ProductGroupID']==null?0:json['ProductGroupID'];
    productGroupName = json['ProductGroupName']==null?"":json['ProductGroupName'];
    productGroupImage = json['ProductGroupImage']==null?"":json['ProductGroupImage'];
    brandID = json['BrandID']==null?0:json['BrandID'];
    brandName = json['BrandName']==null?"":json['BrandName'];
    brandImage = json['BrandImage']==null?"":json['BrandImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.productID;
    data['BestSellingProductName'] = this.bestSellingProductName;
    data['BestSellingQuantity'] = this.bestSellingQuantity;
    data['Unit'] = this.unit;
    data['UnitPrice'] = this.unitPrice;
    data['DiscountPercent'] = this.discountPercent;
    data['ProductSpecification'] = this.productSpecification;
    data['ProductImage'] = this.productImage;
    data['ProductGroupID'] = this.productGroupID;
    data['ProductGroupName'] = this.productGroupName;
    data['ProductGroupImage'] = this.productGroupImage;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['BrandImage'] = this.brandImage;
    return data;
  }
}