/*pkID:
CustomerID:1
InvoiceNo:12
Name:sample.pdf
CompanyId:4135
LoginUserId:admin*/

class PdfUploadRequest {
  String pkID;
  String CustomerID;
  String InvoiceNo;
  String Name;
  String CompanyId;
  String LoginUserId;

  PdfUploadRequest(
      {this.pkID,
      this.CustomerID,
      this.InvoiceNo,
      this.Name,
      this.CompanyId,
      this.LoginUserId});

  PdfUploadRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    CustomerID = json['CustomerID'];
    InvoiceNo = json['InvoiceNo'];
    Name = json['Name'];
    CompanyId = json['CompanyId'];
    LoginUserId = json['LoginUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['pkID'] = this.pkID;
    data['CustomerID'] = this.CustomerID;
    data['InvoiceNo'] = this.InvoiceNo;
    data['Name'] = this.Name;
    data['CompanyId'] = this.CompanyId;
    data['LoginUserId'] = this.LoginUserId;

    return data;
  }
}
