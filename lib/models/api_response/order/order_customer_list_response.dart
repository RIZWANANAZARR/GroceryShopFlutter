class OrderCustomerListResponse {
  List<OrderCustomerListResponseDetails> details;
  int totalCount;

  OrderCustomerListResponse({this.details, this.totalCount});

  OrderCustomerListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new OrderCustomerListResponseDetails.fromJson(v));
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

class OrderCustomerListResponseDetails {
  int pkID;
  int customerID;
  String customerName;
  String address;
  String contactNo;
  String emailAddress;
  String profileImage;
  String remarks;
  String InvoiceNo;
  String InvoiceDate;
  double NetAmount;
  double VatAmount;
  double NetTotal;

  OrderCustomerListResponseDetails(
      {this.pkID,
      this.customerID,
      this.customerName,
      this.address,
      this.contactNo,
      this.emailAddress,
      this.profileImage,
      this.remarks,
      this.InvoiceNo,
      this.InvoiceDate,
      this.NetAmount,
      this.VatAmount,
      this.NetTotal});

  OrderCustomerListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    address = json['Address'] == null ? "" : json['Address'];
    contactNo = json['ContactNo'] == null ? "" : json['ContactNo'];
    emailAddress = json['EmailAddress'] == null ? "" : json['EmailAddress'];
    profileImage = json['ProfileImage'] == null ? "" : json['ProfileImage'];
    remarks = json['Remarks'] == null ? "" : json['Remarks'];
    InvoiceNo = json['OrderNo'] == null ? "" : json['OrderNo'];
    InvoiceDate = json['InvoiceDate'] == null ? "" : json['InvoiceDate'];
    NetAmount = json['NetAmount'] == null ? 0.00 : json['NetAmount'];
    VatAmount = json['VatAmount'] == null ? 0.00 : json['VatAmount'];
    NetTotal = json['NetTotal'] == null ? 0.00 : json['NetTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = this.pkID;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['Address'] = this.address;
    data['ContactNo'] = this.contactNo;
    data['EmailAddress'] = this.emailAddress;
    data['ProfileImage'] = this.profileImage;
    data['Remarks'] = this.remarks;
    data['OrderNo'] = this.InvoiceNo;
    data['InvoiceDate'] = this.InvoiceDate;
    data['NetAmount'] = this.NetAmount;
    data['VatAmount'] = this.VatAmount;
    data['NetTotal'] = this.NetTotal;

    return data;
  }
}
