class OrderProductJsonDetails {
  int pkID; //       "pkID" : 0,
  String InvoiceDate; //               "OrderDate": "2022-06-03",
  int productID; //               "ProductID": 1,
  double quantity; //               "Quantity": 3,
  double dispatchQuantity; //               "DispatchQuantity": 5,
  String unit; //               "Unit": "LTR",
  double unitPrice; //              "UnitRate": 80.00,
  double discountPercent; //               "DiscountPercent": 5.00,
  String loginUserID; //  "LoginUserID" : "admin",
  int companyId; //   "CompanyId": 4135
  String DeliveryDate; //  "DeliveryDate": "2022-06-03",
  double NetAmount; //               "NetAmount": 250,
  double NetRate; //               "NetRate" : 0,
  double Vat; //              "Vat": 20,
  double VatAmount; //               "VatAmount": 200,
  String ProductName; //
  String Remarks;

  OrderProductJsonDetails(
      {this.productID,
      this.ProductName,
      this.unit,
      this.unitPrice,
      //this.productImage,
      this.discountPercent,
      this.quantity,
      this.pkID,
      // this.status,
      this.dispatchQuantity,
      // this.remarks,
      this.loginUserID,
      this.companyId,
      // this.InvoiceNo,
      this.InvoiceDate,
      this.DeliveryDate,
      this.NetAmount,
      this.NetRate,
      this.Vat,
      this.VatAmount,
      this.Remarks});

  OrderProductJsonDetails.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID'];
    ProductName = json['ProductName'];
    unit = json['Unit'];
    unitPrice = json['UnitRate'];
    // productImage = json['ProductImage'];
    discountPercent = json['DiscountPercent'];
    quantity = json['Quantity'];
    pkID = json['pkID'];
    // status = json['Status'];
    dispatchQuantity = json['DispatchQuantity'];
    //remarks = json['Remarks'];
    loginUserID = json['LoginUserID'];
    companyId = json['CompanyId'];
    //InvoiceNo = json['InvoiceNo'];
    InvoiceDate = json['OrderDate'];
    DeliveryDate = json['DeliveryDate'];
    NetAmount = json['NetAmount'];
    NetRate = json['NetRate'];
    Vat = json['Vat'];
    VatAmount = json['VatAmount'];
    Remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.productID;
    data['Unit'] = this.unit;
    data['UnitRate'] = this.unitPrice;
    //data['ProductImage'] = this.productImage;
    data['DiscountPercent'] = this.discountPercent;
    data['Quantity'] = this.quantity;
    data['pkID'] = this.pkID;
    //data['Status'] = this.status;
    data['DispatchQuantity'] = this.dispatchQuantity;
    //data['Remarks'] = this.remarks;
    data['LoginUserID'] = this.loginUserID;
    data['CompanyId'] = this.companyId;
    //data['InvoiceNo'] = this.InvoiceNo;
    data['OrderDate'] = this.InvoiceDate;
    data['DeliveryDate'] = this.DeliveryDate;
    data['NetAmount'] = this.NetAmount;
    data['NetRate'] = this.NetRate;
    data['Vat'] = this.Vat;
    data['VatAmount'] = this.VatAmount;
    data['Remarks'] = this.Remarks;
    return data;
  }
}
