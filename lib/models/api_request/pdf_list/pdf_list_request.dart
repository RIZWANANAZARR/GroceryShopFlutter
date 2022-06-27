/*pkID:
CustomerID:1
InvoiceNo:12
Name:sample.pdf
CompanyId:4135
LoginUserId:admin*/

class PdfListRequest {
  String CustomerID;

  String CompanyId;
  String SearchKey;
  String CustomerType;

  PdfListRequest(
      {this.CustomerID, this.CompanyId, this.SearchKey, this.CustomerType});

  PdfListRequest.fromJson(Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];

    CompanyId = json['CompanyId'];
    SearchKey = json['SearchKey'];
    CustomerType = json['CustomerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();

    data['CustomerID'] = this.CustomerID;

    data['CompanyId'] = this.CompanyId;
    data['SearchKey'] = this.SearchKey;
    data['CustomerType'] = this.CustomerType;

    return data;
  }
}
