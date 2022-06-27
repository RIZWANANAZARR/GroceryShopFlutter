class ManagePaymentListResponse {
  List<ManagePaymentListResponseDetails> details;
  int totalCount;

  ManagePaymentListResponse({this.details, this.totalCount});

  ManagePaymentListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ManagePaymentListResponseDetails.fromJson(v));
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

class ManagePaymentListResponseDetails {
  int rowNum;
  int pkID;
  String poNO;
  int customerID;
  String customerName;
  String paymentType;
  double paymentAmt;
  String paymentDate;
  String transactionStatus;
  String createdDate;
  String createdBy;

  ManagePaymentListResponseDetails({
    this.rowNum,
    this.pkID,
    this.poNO,
    this.customerID,
    this.customerName,
    this.paymentType,
    this.paymentAmt,
    this.paymentDate,
    this.transactionStatus,
    this.createdDate,
    this.createdBy,
  });

  ManagePaymentListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    poNO = json['PoNO'] == null ? "" : json['PoNO'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    paymentType = json['PaymentType'] == null ? "" : json['PaymentType'];
    paymentAmt = json['PaymentAmt'] == null ? "" : json['PaymentAmt'];
    paymentDate = json['PaymentDate'] == null ? "" : json['PaymentDate'];
    transactionStatus =
        json['TransactionStatus'] == null ? "" : json['TransactionStatus'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['PoNO'] = this.poNO;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['PaymentType'] = this.paymentType;
    data['PaymentAmt'] = this.paymentAmt;
    data['PaymentDate'] = this.paymentDate;
    data['TransactionStatus'] = this.transactionStatus;
    data['CreatedDate'] = this.createdDate;
    data['CreatedBy'] = this.createdBy;

    return data;
  }
}
