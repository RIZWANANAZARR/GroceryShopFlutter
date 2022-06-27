/*

PoNo:PO-MAY-019
CustomerID:7
PaymentType:COD
PaymentAmt:1000
PaymentDate:2022-05-27
TransactionStatus:Done
LoginUserID:sahil
CompanyId:4135

*/
class ManagePaymentSaveRequest {
  String PoNo;
  String CustomerID;
  String PaymentType;
  String PaymentAmt;
  String PaymentDate;
  String TransactionStatus;
  String LoginUserID;
  String CompanyId;

  ManagePaymentSaveRequest(
      {this.PoNo,
      this.CustomerID,
      this.PaymentType,
      this.PaymentAmt,
      this.PaymentDate,
      this.TransactionStatus,
      this.LoginUserID,
      this.CompanyId});

  ManagePaymentSaveRequest.fromJson(Map<String, dynamic> json) {
    PoNo = json['PoNo'];
    CustomerID = json['CustomerID'];
    PaymentType = json['PaymentType'];
    PaymentAmt = json['PaymentAmt'];
    PaymentDate = json['PaymentDate'];
    TransactionStatus = json['TransactionStatus'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PoNo'] = this.PoNo;
    data['CustomerID'] = this.CustomerID;
    data['PaymentType'] = this.PaymentType;
    data['PaymentAmt'] = this.PaymentAmt;
    data['PaymentDate'] = this.PaymentDate;
    data['TransactionStatus'] = this.TransactionStatus;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
