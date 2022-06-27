class ExclusiveOfferListResponse {
  List<ExclusiveOfferListResponseDetails> details;
  int totalCount;

  ExclusiveOfferListResponse({this.details, this.totalCount});

  ExclusiveOfferListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ExclusiveOfferListResponseDetails.fromJson(v));
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

class ExclusiveOfferListResponseDetails {
  int productID;
  String productName;
  double discountPercent;
  String unit;
  double unitPrice;
  String productSpecification;
  String productImage;
  int productGroupID;
  String productGroupName;
  String productGroupImage;
  int brandID;
  String brandName;
  String brandImage;

  ExclusiveOfferListResponseDetails(
      {this.productID,
        this.productName,
        this.discountPercent,
        this.unit,
        this.unitPrice,
        this.productSpecification,
        this.productImage,
        this.productGroupID,
        this.productGroupName,
        this.productGroupImage,
        this.brandID,
        this.brandName,
        this.brandImage});

  ExclusiveOfferListResponseDetails.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID']==null?0:json['ProductID'];
    productName = json['ProductName']==null?"":json['ProductName'];
    discountPercent = json['DiscountPercent']==null?0.00:json['DiscountPercent'];
    unit = json['Unit']==null?"":json['Unit'];
    unitPrice = json['UnitPrice']==null?0.00:json['UnitPrice'];
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
    data['ProductName'] = this.productName;
    data['DiscountPercent'] = this.discountPercent;
    data['Unit'] = this.unit;
    data['UnitPrice'] = this.unitPrice;
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