class OrderProductListResponse {
  List<OrderProductListResponseDetails> details;
  int totalCount;

  OrderProductListResponse({this.details, this.totalCount});

  OrderProductListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new OrderProductListResponseDetails.fromJson(v));
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

class OrderProductListResponseDetails {
  int pkID;
  int productID;
  String productName;
  String unit;
  double unitPrice;
  String productImage;
  double discountPercent;
  String status;
  double dispatchQuantity;
  double quantity;
  String remarks;
  String createdBy;
  String InvoiceNo;
  String InvoiceDate;
  double Vat;
  String Remarks;

  String DeliveryDate;
  String CreatedDate;
  String UpdatedBy;
  String UpdatedDate;
  double ClosingSTK;

  OrderProductListResponseDetails(
      {this.pkID,
      this.productID,
      this.productName,
      this.unit,
      this.unitPrice,
      this.productImage,
      this.discountPercent,
      this.status,
      this.dispatchQuantity,
      this.quantity,
      this.remarks,
      this.createdBy,
      this.InvoiceNo,
      this.InvoiceDate,
      this.Vat,
      this.Remarks,
      this.CreatedDate,
      this.DeliveryDate,
      this.UpdatedBy,
      this.UpdatedDate,
      this.ClosingSTK});

  OrderProductListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    unitPrice = json['UnitRate'] == null || json['UnitRate'] == ""
        ? 0.00
        : json['UnitRate'];
    productImage = json['ProductImage'] == null ? "" : json['ProductImage'];
    discountPercent =
        json['DiscountPercent'] == null || json['DiscountPercent'] == ""
            ? 0.00
            : json['DiscountPercent'];
    status = json['Status'] == null ? "" : json['Status'];
    dispatchQuantity =
        json['DispatchQuantity'] == null || json['DispatchQuantity'] == ""
            ? 0.00
            : json['DispatchQuantity'];
    quantity = json['Quantity'] == null || json['Quantity'] == ""
        ? 0.00
        : json['Quantity'];
    remarks = json['Remarks'] == null ? "" : json['Remarks'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    InvoiceNo = json['OrderNo'] == null ? "" : json['OrderNo'];
    InvoiceDate = json['OrderDate'] == null ? "" : json['OrderDate'];
    Vat = json['Vat'] == null ? 0.00 : json['Vat'];
    Remarks = json['Remarks'] == null ? "" : json['Remarks'];
    DeliveryDate = json['DeliveryDate'] == null ? "" : json['DeliveryDate'];
    CreatedDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    UpdatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    UpdatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];

    ClosingSTK = json['ClosingSTK'] == null ? 0.00 : json['ClosingSTK'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['Unit'] = this.unit;
    data['UnitRate'] = this.unitPrice;
    data['ProductImage'] = this.productImage;
    data['DiscountPercent'] = this.discountPercent;
    data['Status'] = this.status;
    data['DispatchQuantity'] = this.dispatchQuantity;
    data['Quantity'] = this.quantity;
    data['Remarks'] = this.remarks;
    data['CreatedBy'] = this.createdBy;
    data['OrderNo'] = this.InvoiceNo;
    data['OrderDate'] = this.InvoiceDate;
    data['Vat'] = this.Vat;
    data['Remarks'] = this.Remarks;

    data['DeliveryDate'] = this.DeliveryDate;
    data['CreatedDate'] = this.CreatedDate;
    data['UpdatedBy'] = this.UpdatedBy;
    data['UpdatedDate'] = this.UpdatedDate;
    data['ClosingSTK'] = this.ClosingSTK;

    return data;
  }
}
