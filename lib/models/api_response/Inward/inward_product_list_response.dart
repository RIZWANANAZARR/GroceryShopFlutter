class InwardProductListResponse {
  List<InwardProductListResponseDetails> details;
  int totalCount;

  InwardProductListResponse({this.details, this.totalCount});

  InwardProductListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new InwardProductListResponseDetails.fromJson(v));
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

class InwardProductListResponseDetails {
  int rowNum;
  int pkID;
  String inwardNo;
  String inwardDate;
  int customerID;
  String customerName;
  int productID;
  String productName;
  String productSpecification;
  double quantity;
  String unit;
  double unitRate;
  double amount;
  double netAmount;
  double vat;

  InwardProductListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.inwardNo,
      this.inwardDate,
      this.customerID,
      this.customerName,
      this.productID,
      this.productName,
      this.productSpecification,
      this.quantity,
      this.unit,
      this.unitRate,
      this.amount,
      this.netAmount,
      this.vat});

  InwardProductListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    inwardNo = json['InwardNo'] == null ? "" : json['InwardNo'];
    inwardDate = json['InwardDate'] == null ? "" : json['InwardDate'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    productSpecification = json['ProductSpecification'] == null
        ? ""
        : json['ProductSpecification'];
    quantity = json['Quantity'] == null ? 0.00 : json['Quantity'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    unitRate = json['UnitRate'] == null ? 0.00 : json['UnitRate'];
    amount = json['Amount'] == null ? 0.00 : json['Amount'];
    netAmount = json['NetAmount'] == null ? 0.00 : json['NetAmount'];
    vat = json['Vat'] == null ? 0.00 : json['Vat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InwardNo'] = this.inwardNo;
    data['InwardDate'] = this.inwardDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['ProductSpecification'] = this.productSpecification;
    data['Quantity'] = this.quantity;
    data['Unit'] = this.unit;
    data['UnitRate'] = this.unitRate;
    data['Amount'] = this.amount;
    data['NetAmount'] = this.netAmount;
    data['Vat'] = this.vat;
    return data;
  }
}
