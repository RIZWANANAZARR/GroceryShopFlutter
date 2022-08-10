/*class ProductReportingListResponse {
  List<ProductReportingListResponseDetails> details;
  int totalCount;

  ProductReportingListResponse({this.details, this.totalCount});

  ProductReportingListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductReportingListResponseDetails.fromJson(v));
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

class ProductReportingListResponseDetails {
  int pkID;
  String productName;
  String productAlias;
  String productFullName;
  String productImage;
  double openingSTK;
  double closingSTK;
  double inwardSTK;
  double outwardSTK;
  double unitPrice;
  double vatPercent;
  double vatAmount;

  ProductReportingListResponseDetails(
      {this.pkID,
      this.productName,
      this.productAlias,
      this.productFullName,
      this.productImage,
      this.openingSTK,
      this.closingSTK,
      this.inwardSTK,
      this.outwardSTK,
      this.unitPrice,
      this.vatPercent,
      this.vatAmount});

  ProductReportingListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    productAlias = json['ProductAlias'] == null ? "" : json['ProductAlias'];
    productFullName =
        json['ProductFullName'] == null ? "" : json['ProductFullName'];
    productImage = json['ProductImage'] == null ? "" : json['ProductImage'];
    openingSTK = json['OpeningSTK'] = null ? 0.00 : json['OpeningSTK'];
    closingSTK = json['ClosingSTK'] = null ? 0.00 : json['ClosingSTK'];
    inwardSTK = json['InwardSTK'] = null ? 0.00 : json['InwardSTK'];
    outwardSTK = json['OutwardSTK'] = null ? 0.00 : json['OutwardSTK'];
    unitPrice = json['UnitPrice'] = null ? 0.00 : json['UnitPrice'];
    vatPercent = json['VatPercent'] = null ? 0.00 : json['VatPercent'];
    vatAmount = json['VatAmount'] = null ? 0.00 : json['VatAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ProductName'] = this.productName;
    data['ProductAlias'] = this.productAlias;
    data['ProductFullName'] = this.productFullName;
    data['ProductImage'] = this.productImage;
    data['OpeningSTK'] = this.openingSTK;
    data['ClosingSTK'] = this.closingSTK;
    data['InwardSTK'] = this.inwardSTK;
    data['OutwardSTK'] = this.outwardSTK;
    data['UnitPrice'] = this.unitPrice;
    data['VatPercent'] = this.vatPercent;
    data['VatAmount'] = this.vatAmount;
    return data;
  }
}*/
class ProductReportingListResponse {
  List<ProductReportingListResponseDetails> details;
  int totalCount;

  ProductReportingListResponse({this.details, this.totalCount});

  ProductReportingListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductReportingListResponseDetails.fromJson(v));
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

class ProductReportingListResponseDetails {
  int pkID;
  String productName;
  String productAlias;
  String productFullName;
  String productImage;
  double openingSTK;
  double closingSTK;
  double inwardSTK;
  double outwardSTK;
  double unitPrice;
  double vatPercent;
  double vatAmount;

  ProductReportingListResponseDetails(
      {this.pkID,
      this.productName,
      this.productAlias,
      this.productFullName,
      this.productImage,
      this.openingSTK,
      this.closingSTK,
      this.inwardSTK,
      this.outwardSTK,
      this.unitPrice,
      this.vatPercent,
      this.vatAmount});

  ProductReportingListResponseDetails.fromJson(Map<String, dynamic> json) {
    /* pkID = json['pkID'] == null ? 0 : json['pkID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    productAlias = json['ProductAlias'] == null ? "" : json['ProductAlias'];
    productFullName =
        json['ProductFullName'] == null ? "" : json['ProductFullName'];
    productImage = json['ProductImage'] == null ? "" : json['ProductImage'];
    openingSTK = json['OpeningSTK'] = null ? 0.00 : json['OpeningSTK'];
    closingSTK = json['ClosingSTK'] = null ? 0.00 : json['ClosingSTK'];
    inwardSTK = json['InwardSTK'] = null ? 0.00 : json['InwardSTK'];
    outwardSTK = json['OutwardSTK'] = null ? 0.00 : json['OutwardSTK'];
    unitPrice = json['UnitPrice'] = null ? 0.00 : json['UnitPrice'];
    vatPercent = json['VatPercent'] = null ? 0.00 : json['VatPercent'];
    vatAmount = json['VatAmount'] = null ? 0.00 : json['VatAmount'];
*/
    pkID = json['pkID'];
    productName = json['ProductName'];
    productAlias = json['ProductAlias'];
    productFullName = json['ProductFullName'];
    productImage = json['ProductImage'];
    openingSTK = json['OpeningSTK'];
    closingSTK = json['ClosingSTK'];
    inwardSTK = json['InwardSTK'];
    outwardSTK = json['OutwardSTK'];
    unitPrice = json['UnitPrice'];
    vatPercent = json['VatPercent'];
    vatAmount = json['VatAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ProductName'] = this.productName;
    data['ProductAlias'] = this.productAlias;
    data['ProductFullName'] = this.productFullName;
    data['ProductImage'] = this.productImage;
    data['OpeningSTK'] = this.openingSTK;
    data['ClosingSTK'] = this.closingSTK;
    data['InwardSTK'] = this.inwardSTK;
    data['OutwardSTK'] = this.outwardSTK;
    data['UnitPrice'] = this.unitPrice;
    data['VatPercent'] = this.vatPercent;
    data['VatAmount'] = this.vatAmount;
    return data;
  }
}
