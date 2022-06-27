class TabProductListResponse {
  List<TabProductListResponseDetails> details;
  int totalCount;

  TabProductListResponse({this.details, this.totalCount});

  TabProductListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new TabProductListResponseDetails.fromJson(v));
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

class TabProductListResponseDetails {
  int pkID;
  String productName;
  int productGroupID;
  String productGroupName;
  String productAlias;
  String unit;
  double unitPrice;
  String productSpecification;
  bool activeFlag;
  String productImage;
  double discountPercent;
  double vat;

  TabProductListResponseDetails(
      {this.pkID,
      this.productName,
      this.productGroupID,
      this.productGroupName,
      this.productAlias,
      this.unit,
      this.unitPrice,
      this.productSpecification,
      this.activeFlag,
      this.productImage,
      this.discountPercent,
      this.vat});

  TabProductListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    productGroupID =
        json['ProductGroupID'] == null ? 0 : json['ProductGroupID'];
    productGroupName =
        json['ProductGroupName'] == null ? "" : json['ProductGroupName'];
    productAlias = json['ProductAlias'] == null ? "" : json['ProductAlias'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    unitPrice = json['UnitPrice'] == null ? 0.00 : json['UnitPrice'];
    productSpecification = json['ProductSpecification'] == null
        ? ""
        : json['ProductSpecification'];
    activeFlag = json['ActiveFlag'] == null ? false : json['ActiveFlag'];
    productImage = json['ProductImage'] == null ? "" : json['ProductImage'];
    discountPercent =
        json['DiscountPercent'] == null ? 0.00 : json['DiscountPercent'];
    vat = json['vat'] == null ? 0.00 : json['vat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ProductName'] = this.productName;
    data['ProductGroupID'] = this.productGroupID;
    data['ProductGroupName'] = this.productGroupName;
    data['ProductAlias'] = this.productAlias;
    data['Unit'] = this.unit;
    data['UnitPrice'] = this.unitPrice;
    data['ProductSpecification'] = this.productSpecification;
    data['ActiveFlag'] = this.activeFlag;
    data['ProductImage'] = this.productImage;
    data['DiscountPercent'] = this.discountPercent;
    data['vat'] = this.vat;
    return data;
  }
}
