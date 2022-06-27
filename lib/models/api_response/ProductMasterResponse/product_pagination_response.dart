class ProductPaginationResponse {
  List<ProductPaginationDetails> details;
  int totalCount;

  ProductPaginationResponse({this.details, this.totalCount});

  ProductPaginationResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductPaginationDetails.fromJson(v));
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

class ProductPaginationDetails {
  int rowNum;
  int pkID;
  String productName;
  String productNameLong;
  String productSpecification;
  String productAlias;
  String productImage;
  String unit;
  double discountPercent;
  double unitPrice;
  int productGroupID;
  String productGroupName;
  String productGroupImage;
  int brandID;
  String brandName;
  String brandImage;
  bool activeFlag;
  String activeFlagDesc;
  double openingSTK;
  double closingSTK;
  double vat;
  double vatAmount;
  double NetAmount;
  double InwardSTK;
  double OutwardSTK;

  ProductPaginationDetails(
      {this.rowNum,
      this.pkID,
      this.productName,
      this.productNameLong,
      this.productSpecification,
      this.productAlias,
      this.productImage,
      this.unit,
      this.discountPercent,
      this.unitPrice,
      this.productGroupID,
      this.productGroupName,
      this.productGroupImage,
      this.brandID,
      this.brandName,
      this.brandImage,
      this.activeFlag,
      this.activeFlagDesc,
      this.openingSTK,
      this.closingSTK,
      this.vat,
      this.vatAmount,
      this.NetAmount,
      this.InwardSTK,
      this.OutwardSTK});

  ProductPaginationDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    productNameLong =
        json['ProductNameLong'] == null ? "" : json['ProductNameLong'];
    productSpecification = json['ProductSpecification'] == null
        ? ""
        : json['ProductSpecification'];
    productAlias = json['ProductAlias'] == null ? "" : json['ProductAlias'];
    productImage = json['ProductImage'] == null ? "" : json['ProductImage'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    discountPercent =
        json['DiscountPercent'] == null ? 0.00 : json['DiscountPercent'];
    unitPrice = json['UnitPrice'] == null ? 0.00 : json['UnitPrice'];
    productGroupID =
        json['ProductGroupID'] == null ? 0 : json['ProductGroupID'];
    productGroupName =
        json['ProductGroupName'] == null ? "" : json['ProductGroupName'];
    productGroupImage =
        json['ProductGroupImage'] == null ? "" : json['ProductGroupImage'];
    brandID = json['BrandID'] == null ? 0 : json['BrandID'];
    brandName = json['BrandName'] == null ? "" : json['BrandName'];
    brandImage = json['BrandImage'] == null ? "" : json['BrandImage'];
    activeFlag = json['ActiveFlag'] == null ? false : json['ActiveFlag'];
    activeFlagDesc =
        json['ActiveFlagDesc'] == null ? "" : json['ActiveFlagDesc'];
    openingSTK = json['OpeningSTK'] == null ? 0.00 : json['OpeningSTK'];
    closingSTK = json['ClosingSTK'] == null ? 0.00 : json['ClosingSTK'];
    vat = json['vat'] == null ? 0.00 : json['vat'];
    vatAmount = json['vatAmount'] == null ? 0.00 : json['vatAmount'];
    NetAmount = json['NetAmount'] == null ? 0.00 : json['NetAmount'];
    InwardSTK = json['InwardStk'] == null ? 0.00 : json['InwardStk'];
    OutwardSTK = json['OutwardStk'] == null ? 0.00 : json['OutwardStk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ProductName'] = this.productName;
    data['ProductNameLong'] = this.productNameLong;
    data['ProductSpecification'] = this.productSpecification;
    data['ProductAlias'] = this.productAlias;
    data['ProductImage'] = this.productImage;
    data['Unit'] = this.unit;
    data['DiscountPercent'] = this.discountPercent;
    data['UnitPrice'] = this.unitPrice;
    data['ProductGroupID'] = this.productGroupID;
    data['ProductGroupName'] = this.productGroupName;
    data['ProductGroupImage'] = this.productGroupImage;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['BrandImage'] = this.brandImage;
    data['ActiveFlag'] = this.activeFlag;
    data['ActiveFlagDesc'] = this.activeFlagDesc;
    data['OpeningSTK'] = this.openingSTK;
    data['ClosingSTK'] = this.closingSTK;
    data['vat'] = this.vat;
    data['NetAmount'] = this.NetAmount;
    data['vatAmount'] = this.vatAmount;
    data['InwardStk'] = this.InwardSTK;
    data['OutwardStk'] = this.OutwardSTK;
    return data;
  }
}
