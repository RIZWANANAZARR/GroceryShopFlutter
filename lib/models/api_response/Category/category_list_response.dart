class CategoryListResponse {
  List<CategoryListResponseDetails> details;
  int totalCount;

  CategoryListResponse({this.details, this.totalCount});

  CategoryListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CategoryListResponseDetails.fromJson(v));
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

class CategoryListResponseDetails {
  int productID;
  String productName;
  String productAlias;
  int productGroupID;
  String productGroupName;
  int brandID;
  String brandName;
  String unit;
  double unitPrice;
  String productSpecification;
  bool activeFlag;
  String productImage;
  double closingSTK;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  double Vat;

  CategoryListResponseDetails(
      {this.productID,
      this.productName,
      this.productAlias,
      this.productGroupID,
      this.productGroupName,
      this.brandID,
      this.brandName,
      this.unit,
      this.unitPrice,
      this.productSpecification,
      this.activeFlag,
      this.productImage,
      this.closingSTK,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.Vat});

  CategoryListResponseDetails.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    productAlias = json['ProductAlias'] == null ? "" : json['ProductAlias'];
    productGroupID =
        json['ProductGroupID'] == null ? 0 : json['ProductGroupID'];
    productGroupName =
        json['ProductGroupName'] == null ? "" : json['ProductGroupName'];
    brandID = json['BrandID'] == null ? 0 : json['BrandID'];
    brandName = json['BrandName'] == null ? "" : json['BrandName'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    unitPrice = json['UnitPrice'] == null ? 0.00 : json['UnitPrice'];
    productSpecification = json['ProductSpecification'] == null
        ? ""
        : json['ProductSpecification'];
    activeFlag = json['ActiveFlag'] == null ? false : json['ActiveFlag'];
    productImage = json['ProductImage'] == null ? "" : json['ProductImage'];
    closingSTK = json['ClosingSTK'] == null ? 0.00 : json['ClosingSTK'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
    Vat = json['Vat'] == null ? 0.00 : json['Vat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['ProductAlias'] = this.productAlias;
    data['ProductGroupID'] = this.productGroupID;
    data['ProductGroupName'] = this.productGroupName;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['Unit'] = this.unit;
    data['UnitPrice'] = this.unitPrice;
    data['ProductSpecification'] = this.productSpecification;
    data['ActiveFlag'] = this.activeFlag;
    data['ProductImage'] = this.productImage;
    data['ClosingSTK'] = this.closingSTK;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['Vat'] = this.Vat;
    return data;
  }
}
