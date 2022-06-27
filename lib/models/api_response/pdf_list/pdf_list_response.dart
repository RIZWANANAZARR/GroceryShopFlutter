class PDFListResponse {
  List<PDFListResponseDetails> details;
  int totalCount;

  PDFListResponse({this.details, this.totalCount});

  PDFListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PDFListResponseDetails.fromJson(v));
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

class PDFListResponseDetails {
  int pkID;
  int customerID;
  String customerName;
  String contactNo;
  String address;
  String emailAddress;
  String fileName;
  String invoiceNo;

  PDFListResponseDetails(
      {this.pkID,
      this.customerID,
      this.customerName,
      this.contactNo,
      this.address,
      this.emailAddress,
      this.fileName,
      this.invoiceNo});

  PDFListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    contactNo = json['ContactNo'];
    address = json['Address'];
    emailAddress = json['EmailAddress'];
    fileName = json['FileName'];
    invoiceNo = json['InvoiceNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ContactNo'] = this.contactNo;
    data['Address'] = this.address;
    data['EmailAddress'] = this.emailAddress;
    data['FileName'] = this.fileName;
    data['InvoiceNo'] = this.invoiceNo;
    return data;
  }
}
